# Query current worktrees on each completion; Codex nests each checkout under
# its repository name, so use the parent directory to distinguish those trees.
function __wt_worktrees
    set -l repo_name
    command git worktree list --porcelain 2>/dev/null | string match --regex --groups-only '^worktree (.*)$' | while read -l directory
        set -l name (path basename -- "$directory")
        if not set -q repo_name[1]
            set repo_name "$name"
        else if test "$name" = "$repo_name"
            set name (path basename -- (path dirname -- "$directory"))
        end
        printf '%s\t%s\n' "$name" "$directory"
    end
end

complete -c wt -f -n '__fish_is_nth_token 1' -a '(__wt_worktrees)'
