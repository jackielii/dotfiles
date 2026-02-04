#!/bin/bash

if [[ $TMUX != "" ]]; then
  tmux display-popup -E -w 90% -h 90% nvim "$@"
# elif [[ -n "$KITTY_WINDOW_ID" ]]; then
#   kitten @ launch --type=overlay \
#     --wait-for-child-to-exit \
#     --title="Claude Code Editor" \
#     --logo="$HOME/.claude/claude-logo.png" \
#     --logo-position=bottom-right \
#     --logo-alpha=0.2 \
#     nvim -c "hi Normal guibg=NONE ctermbg=NONE" -c "hi NormalNC guibg=NONE ctermbg=NONE" "$@"
else
  nvim "$@"
fi
