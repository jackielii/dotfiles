#!/bin/bash
# chrome-clone-guard launch watcher: log every new Google Chrome browser
# process with its parent chain, to find what launched (and killed) ~950
# Chromes/hour on 2026-11-05. Temporary diagnostic; remove once found.

set -u
PATH=/usr/bin:/bin:/usr/sbin:/sbin

LOG_DIR="$HOME/Library/Logs/chrome-clone-guard"
LOG="$LOG_DIR/launches.log"
mkdir -p "$LOG_DIR"

seen=" "
while :; do
  snap=$(ps -axo pid=,ppid=,command= | sed 's/^ *//')
  new_seen=" "
  while IFS= read -r line; do
    pid=${line%% *}; rest=${line#* }; rest=${rest#"${rest%%[! ]*}"}
    ppid=${rest%% *}; cmd=${rest#* }
    case "$cmd" in
      "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"*|*/code_sign_clone.*/Contents/MacOS/Google\ Chrome*) ;;
      *) continue ;;
    esac
    new_seen="$new_seen$pid "
    case "$seen" in *" $pid "*) continue ;; esac
    chain=""
    p=$ppid
    for _ in 1 2 3 4 5 6; do
      [ -n "$p" ] && [ "$p" -gt 1 ] 2>/dev/null || break
      pl=$(printf '%s\n' "$snap" | awk -v p="$p" '$1==p {print; exit}')
      [ -n "$pl" ] || break
      pc=$(printf '%s' "$pl" | awk '{ $1=""; $2=""; sub(/^  /,""); print }' | cut -c1-200)
      chain="$chain <- [$p] $pc"
      p=$(printf '%s' "$pl" | awk '{print $2}')
    done
    echo "$(date '+%Y-%m-%d %H:%M:%S') pid=$pid ppid=$ppid cmd=$(printf '%s' "$cmd" | cut -c1-300)$chain" >> "$LOG"
  done <<< "$snap"
  seen=$new_seen

  if [ -f "$LOG" ] && [ "$(wc -c < "$LOG")" -gt 20000000 ]; then
    tail -c 5000000 "$LOG" > "$LOG.tmp" && mv "$LOG.tmp" "$LOG"
  fi
  sleep 0.3
done
