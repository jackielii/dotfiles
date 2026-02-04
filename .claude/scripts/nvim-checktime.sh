#!/bin/bash
# Find the Neovim instance matching current workspace and send checktime
# This is called by Claude Code's PostToolUse hook after Edit/Write operations

LOCK_DIR="$HOME/.claude/ide/nvim-sockets"
CWD="$(pwd)"

shopt -s nullglob

# Find matching lock file by workspace
for lock_file in "$LOCK_DIR"/*.lock; do
  [ -f "$lock_file" ] || continue

  # Check if any workspace folder matches or contains our CWD
  if jq -e --arg cwd "$CWD" '.workspaceFolders | any(. as $ws | $cwd | startswith($ws))' "$lock_file" >/dev/null 2>&1; then
    NVIM_SOCKET=$(jq -r '.nvimSocket' "$lock_file")
    if [ -n "$NVIM_SOCKET" ] && [ -S "$NVIM_SOCKET" ]; then
      nvim --server "$NVIM_SOCKET" --remote-expr 'execute("checktime")' 2>/dev/null
      exit 0
    fi
  fi
done

# No matching Neovim found, exit silently
exit 0
