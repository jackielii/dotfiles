#!/bin/bash
# chrome-clone-guard: prune leaked Google Chrome code_sign_clone folders.
#
# Chrome (feature MacAppCodeSignClone) clones its app bundle into the per-user
# "X" temp dir on every launch and only removes it on a graceful exit. Killed
# or crashed Chromes leak their clone. macOS only empties that dir at boot
# (dirhelper -machineBoot), and with ~10M leaked entries that blocked boot for
# hours on 2026-11-06. This job keeps the pile small.
#
# Safety rule: a clone can belong to a running Chrome only if it was created
# after that Chrome started. So we delete only clones older than the oldest
# running Google Chrome main process (minus a margin), and never anything
# younger than 5 minutes.

set -u
PATH=/usr/bin:/bin:/usr/sbin:/sbin

LOG_DIR="$HOME/Library/Logs/chrome-clone-guard"
LOG="$LOG_DIR/guard.log"
WARN_AT=200
MARGIN=60
MIN_AGE=300
mkdir -p "$LOG_DIR"

user_dir="$(getconf DARWIN_USER_DIR)"
clone_root="$(cd "$user_dir/../X" 2>/dev/null && pwd)/com.google.Chrome.code_sign_clone"
[ -d "$clone_root" ] || exit 0

now=$(date +%s)
cutoff=$((now - MIN_AGE))

# Oldest running Google Chrome main (browser) process start time.
chrome_bin="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
oldest=""
while IFS= read -r line; do
  pid=${line%% *}
  cmd=${line#* }
  case "$cmd" in
    "$chrome_bin"|"$chrome_bin "*|*/code_sign_clone.*/Contents/MacOS/Google\ Chrome|*/code_sign_clone.*/Contents/MacOS/Google\ Chrome\ *) ;;
    *) continue ;;
  esac
  lstart=$(ps -o lstart= -p "$pid" 2>/dev/null) || continue
  [ -n "$lstart" ] || continue
  t=$(date -j -f "%a %b %d %T %Y" "$lstart" +%s 2>/dev/null) || continue
  if [ -z "$oldest" ] || [ "$t" -lt "$oldest" ]; then oldest=$t; fi
done < <(ps -axo pid=,command= | sed 's/^ *//')

if [ -n "$oldest" ] && [ $((oldest - MARGIN)) -lt "$cutoff" ]; then
  cutoff=$((oldest - MARGIN))
fi

total=0
pruned=0
for d in "$clone_root"/code_sign_clone.*; do
  [ -d "$d" ] || continue
  total=$((total + 1))
  m=$(stat -f %m "$d" 2>/dev/null) || continue
  if [ "$m" -lt "$cutoff" ]; then
    rm -rf "$d" && pruned=$((pruned + 1))
  fi
done

ts=$(date '+%Y-%m-%d %H:%M:%S')
if [ "$pruned" -gt 0 ] || [ "$total" -ge "$WARN_AT" ]; then
  echo "$ts total=$total pruned=$pruned oldest_chrome=${oldest:-none}" >> "$LOG"
fi

if [ "$pruned" -ge "$WARN_AT" ]; then
  osascript -e "display notification \"Pruned $pruned leaked Chrome clones. Something is killing Chrome repeatedly; see ~/Library/Logs/chrome-clone-guard.\" with title \"Chrome clone leak\"" >/dev/null 2>&1
fi

# Keep the log small.
if [ -f "$LOG" ] && [ "$(wc -l < "$LOG")" -gt 5000 ]; then
  tail -n 2000 "$LOG" > "$LOG.tmp" && mv "$LOG.tmp" "$LOG"
fi
exit 0
