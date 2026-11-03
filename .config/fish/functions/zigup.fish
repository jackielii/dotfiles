function zigup --description 'Manage Zig with a stable launcher outside the Homebrew Cellar'
    command mkdir -p "$HOME/.local/bin"
    command zigup --path-link "$HOME/.local/bin/zig" $argv
end
