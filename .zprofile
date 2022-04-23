eval "$(/opt/homebrew/bin/brew shellenv)"

# Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        eval "$("$BASE16_SHELL/profile_helper.sh")"

# Base16 fzf
[ -n "$BASE16_THEME" ] && \
	[ -f $HOME/.config/base16-fzf/bash/base16-${BASE16_THEME}.config ] && \
	source $HOME/.config/base16-fzf/bash/base16-${BASE16_THEME}.config

