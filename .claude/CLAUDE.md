# Personal preferences

## Terminals: use Rex

When a command needs my terminal (password/sudo prompts, long-running jobs, anything I should watch or type into), open it as a tab in my Rex session using the `rex` skill. Don't use the Claude desktop app's Terminal panel (`run_in_terminal`) for this.

- `rex` is symlinked at `~/.local/bin/rex`. If it's missing, the binary is at `~/Library/Application Support/com.superlogical.rex/RexServer/Versions/Current/Rex Server.app/Contents/MacOS/rex`.
- Outside Rex terminals `REX_SESSION` is unset: find the session with `rex ls --json` (on mstudio it is labelled "mstudio").
