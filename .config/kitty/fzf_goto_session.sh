#!/bin/bash

# Directory containing session files
SESSION_DIR="$HOME/.local/share/kitty/sessions"

# Check if session directory exists
if [[ ! -d "$SESSION_DIR" ]]; then
    echo "Session directory not found: $SESSION_DIR"
    exit 1
fi

# Find all session files and use fzf to select one
selected=$(find "$SESSION_DIR" -name "*.session" -o -name "*.kitty-session" | \
    sed "s|$SESSION_DIR/||" | \
    fzf --prompt="Select session: " \
        --layout=reverse \
        --border \
        --preview="cat $SESSION_DIR/{}" \
        --preview-window=right:60%)

# If a session was selected, goto it
if [[ -n "$selected" ]]; then
    session_path="$SESSION_DIR/$selected"
    # Use kitten @ action to execute goto_session
    kitten @ action goto_session "$session_path"
fi
