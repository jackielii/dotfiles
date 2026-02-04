#!/usr/bin/env node
"use strict";

const fs = require("fs");
const { execSync } = require("child_process");
const os = require("os");

// Read JSON input from stdin
function readJSON(fd) {
  try {
    return JSON.parse(fs.readFileSync(fd, "utf8"));
  } catch {
    return {};
  }
}

const input = readJSON(0); // stdin
const currentDir = input.workspace?.current_dir || "";
const modelName = input.model?.display_name || "";
const transcript = input.transcript_path;

// Get relative path from home directory
function getDisplayDir(dir) {
  const homeDir = os.homedir();
  if (dir.startsWith(homeDir)) {
    return `~${dir.slice(homeDir.length)}`;
  }
  return dir;
}

// Get git branch information
function getGitInfo(dir) {
  if (!dir) return "";
  
  try {
    // Check if we're in a git repo
    execSync(`git -C "${dir}" rev-parse --git-dir`, { stdio: "ignore" });
    
    let branch = "";
    
    // Method 1: git branch --show-current (Git 2.22+)
    try {
      branch = execSync(`git -C "${dir}" branch --show-current`, { 
        encoding: "utf8", 
        stdio: "pipe" 
      }).trim();
    } catch {}
    
    // Method 2: Fallback for older Git versions
    if (!branch) {
      try {
        branch = execSync(`git -C "${dir}" symbolic-ref --short HEAD`, { 
          encoding: "utf8", 
          stdio: "pipe" 
        }).trim();
      } catch {}
    }
    
    // Method 3: Handle detached HEAD state
    if (!branch) {
      try {
        const commitHash = execSync(`git -C "${dir}" rev-parse --short HEAD`, { 
          encoding: "utf8", 
          stdio: "pipe" 
        }).trim();
        if (commitHash) {
          branch = `detached@${commitHash}`;
        }
      } catch {}
    }
    
    if (branch && branch !== "detached@") {
      return ` \x1b[36;2m(${branch})\x1b[0m`;
    }
  } catch {}
  
  return "";
}

// Context window calculation functions
const CONTEXT_WINDOW = 200_000;

function usedTotal(u) {
  return (
    (u?.input_tokens ?? 0) +
    (u?.output_tokens ?? 0) +
    (u?.cache_read_input_tokens ?? 0) +
    (u?.cache_creation_input_tokens ?? 0)
  );
}

function syntheticModel(j) {
  const m = String(j?.message?.model ?? "").toLowerCase();
  return m === "<synthetic>" || m.includes("synthetic");
}

function assistantMessage(j) {
  return j?.message?.role === "assistant";
}

function subContext(j) {
  return j?.isSidechain === true;
}

function contentNoResponse(j) {
  const c = j?.message?.content;
  return (
    Array.isArray(c) &&
    c.some(
      (x) =>
        x &&
        x.type === "text" &&
        /no\s+response\s+requested/i.test(String(x.text))
    )
  );
}

function parseTs(j) {
  const t = j?.timestamp;
  const n = Date.parse(t);
  return Number.isFinite(n) ? n : -Infinity;
}

// Find the newest main-context entry by timestamp
function newestMainUsageByTimestamp(transcript) {
  if (!transcript) return null;
  let latestTs = -Infinity;
  let latestUsage = null;
  let firstAssistantUsage = null;

  let lines;
  try {
    lines = fs.readFileSync(transcript, "utf8").split(/\r?\n/);
  } catch {
    return null;
  }

  for (let i = 0; i < lines.length; i++) {
    const line = lines[i].trim();
    if (!line) continue;

    let j;
    try {
      j = JSON.parse(line);
    } catch {
      continue;
    }
    
    const u = j.message?.usage;
    
    // Skip invalid entries
    if (
      subContext(j) ||
      syntheticModel(j) ||
      j.isApiErrorMessage === true ||
      contentNoResponse(j) ||
      !assistantMessage(j)
    )
      continue;

    // Capture the first assistant message for initial context
    if (!firstAssistantUsage && assistantMessage(j) && u) {
      firstAssistantUsage = u;
    }
    
    // Skip if no usage data or zero usage
    if (usedTotal(u) === 0) continue;

    const ts = parseTs(j);
    if (ts > latestTs) {
      latestTs = ts;
      latestUsage = u;
    }
    else if (ts == latestTs && usedTotal(u) > usedTotal(latestUsage)) {
      latestUsage = u;
    }
  }
  
  // If we have no usage data yet but have the first assistant message,
  // use that to show the initial context
  if (!latestUsage && firstAssistantUsage) {
    return firstAssistantUsage;
  }
  
  return latestUsage;
}

// Get context window usage info
function getContextInfo() {
  const usage = newestMainUsageByTimestamp(transcript);
  
  if (usage) {
    // We have actual usage data
    const used = usedTotal(usage);
    const pct = CONTEXT_WINDOW > 0 ? Math.round((used * 1000) / CONTEXT_WINDOW) / 10 : 0;
    return ` \x1b[33;2m[${pct.toFixed(1)}%🧠]\x1b[0m`;
  }
  
  // No usage data yet - show estimated initial context
  // This happens at session start before any messages are exchanged
  // Based on actual initial context breakdown:
  // - System prompt: ~2.8k tokens
  // - System tools: ~11.5k tokens  
  // - Memory files: varies, but typically ~150 tokens
  // Total: ~14.5k tokens
  // Always show this estimate when we have a model (indicating we're in Claude Code)
  if (modelName) {
    const estimatedInitial = 14500;
    const pct = CONTEXT_WINDOW > 0 ? Math.round((estimatedInitial * 1000) / CONTEXT_WINDOW) / 10 : 0;
    return ` \x1b[33;2m[~${pct.toFixed(1)}%🧠]\x1b[0m`;
  }
  
  return "";
}

// Build the status line
const displayDir = getDisplayDir(currentDir);
const gitInfo = getGitInfo(currentDir);
const contextInfo = getContextInfo();

process.stdout.write(`\x1b[34;2m${displayDir}\x1b[0m${gitInfo} \x1b[35;2m${modelName}\x1b[0m${contextInfo}`);