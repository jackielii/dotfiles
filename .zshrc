# vim:set noet sts=0 sw=2 ts=2 tw=120 fdm=marker:
#
# # If you come from bash you might have to change your $PATH.
# # export PATH=$HOME/bin:/usr/local/bin:$PATH
# zmodload zsh/zprof # for profiling, use `zprof` to see the results
#
# # Path to your oh-my-zsh installation.
# export ZSH="$HOME/.oh-my-zsh"
#
# # Set name of the theme to load. Optionally, if you set this to "random"
# # it'll load a random theme each time that oh-my-zsh is loaded.
# # See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# # ZSH_THEME="robbyrussell"
# ZSH_THEME="agnoster"
#
# DEFAULT_USER="jackieli"
#
# # Set list of themes to load
# # Setting this variable when ZSH_THEME=random
# # cause zsh load theme from this variable instead of
# # looking in ~/.oh-my-zsh/themes/
# # An empty array have no effect
# # ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )
#
# # Uncomment the following line to use case-sensitive completion.
# # CASE_SENSITIVE="true"
#
# # Uncomment the following line to use hyphen-insensitive completion. Case
# # sensitive completion must be off. _ and - will be interchangeable.
# # HYPHEN_INSENSITIVE="true"
#
# # Uncomment the following line to disable bi-weekly auto-update checks.
# # DISABLE_AUTO_UPDATE="true"
#
# # Uncomment the following line to change how often to auto-update (in days).
# # export UPDATE_ZSH_DAYS=13
#
# # Uncomment the following line to disable colors in ls.
# # DISABLE_LS_COLORS="true"
#
# # Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"
#
# # Uncomment the following line to enable command auto-correction.
# # ENABLE_CORRECTION="true"
#
# # Uncomment the following line to display red dots whilst waiting for completion.
# # COMPLETION_WAITING_DOTS="true"
#
# # Uncomment the following line if you want to disable marking untracked files
# # under VCS as dirty. This makes repository status check for large repositories
# # much, much faster.
# # DISABLE_UNTRACKED_FILES_DIRTY="true"
#
# # Uncomment the following line if you want to change the command execution time
# # stamp shown in the history command output.
# # The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# # HIST_STAMPS="mm/dd/yyyy"
#
# # Would you like to use another custom folder than $ZSH/custom?
# # ZSH_CUSTOM=/path/to/new-custom-folder
#
# # Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# # Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# # Example format: plugins=(rails git textmate ruby lighthouse)
# # Add wisely, as too many plugins slow down shell startup.
#
# VIM_MODE_NO_DEFAULT_BINDINGS=true
#
# OS=$(uname -s)
#
# plugins=(
# 	git
# 	kubectl
# 	# golang
# 	tmux
# 	zsh-autosuggestions
# 	docker
# 	docker-compose
# 	# # zsh-vim-mode
# 	you-should-use
# 	gh
# 	gpg-agent
# 	fzf
# )
#
# # if [ -d ~/.ssh ] && [ -f ~/.ssh/id_rsa ]; then
# # 	plugins=(ssh-agent $plugins)
# # 	zstyle :omz:plugins:ssh-agent identities id_tes_ed25519 id_rsa
# # fi
#
# if [ "${OS}" = "Darwin" ]; then
# 	# use gnu-utils on mac, it sets PATH correctly for ls, grep etc
# 	plugins=(gnu-utils $plugins)
# fi
#
#
# source $ZSH/oh-my-zsh.sh
#
# # User configuration
#
# if [ "${OS}" = "Darwin" ]; then
# 	# use our own ls --color, this is after sourcing the oh-my-zsh.sh
# 	alias ls="\gls --color=auto"
# fi
#
# if [ $TERM = "xterm-kitty" ]; then
# 	alias ssh="kitty +kitten ssh"
# fi
#
# # https://github.com/canonical/lightdm/blob/1.26.0/debian/lightdm-session#L38
# # We put the env vars in .profile because we need the PATH etc to be present
# # for GUI apps. If we source .profile in .zshrc directly, it'll be sourced
# # twice when the tty emulator starts which calls zsh which will eval .zshrc.
# # Hense the following line
# [[ $_DOT_PROFILE_SOURCED != "yes" && -f ~/.profile ]] && source ~/.profile
# [[ $_DOT_PROFILE_SOURCED != "yes" && -f ~/.zprofile ]] && source ~/.zprofile
#
# eval "$(direnv hook zsh)"
# export NODE_VERSIONS="$HOME/.nvm/versions/node" # this enables `use node` in direnv
# export NODE_VERSION_PREFIX=
#
# export MANPATH="/opt/homebrew/share/man:/usr/share/man:/usr/local/share/man:/Applications/kitty.app/Contents/Resources/man:$MANPATH"
#
# # You may need to manually set your language environment
# # export LANG=en_US.UTF-8
#
# # Preferred editor for local and remote sessions
# # if [[ -n $SSH_CONNECTION ]]; then
# #   export EDITOR='vim'
# # else
# #   export EDITOR='mvim'
# # fi
#
# # Compilation flags
# # export ARCHFLAGS="-arch x86_64"
#
# # ssh
# # export SSH_KEY_PATH="~/.ssh/rsa_id"
#
# # Set personal aliases, overriding those provided by oh-my-zsh libs,
# # plugins, and themes. Aliases can be placed here, though oh-my-zsh
# # users are encouraged to define aliases within the ZSH_CUSTOM folder.
# # For a full list of active aliases, run `alias`.
# #
# # Example aliases
# # alias zshconfig="mate ~/.zshrc"
# # alias ohmyzsh="mate ~/.oh-my-zsh"
#
# # {{{ editing mode e=emacs v=vim
# # export KEYTIMEOUT=1
# # bindkey -v
#
# # {{{ nvm.sh
# # the original load nvm is very slow, load manually with . $NVM_DIR/nvm.sh
# export NVM_DIR="$HOME/.nvm"
#
# # {{{ zoxide zsh-z alternative
# # https://github.com/ajeetdsouza/zoxide
# eval "$(zoxide init zsh)"
# # }}}
#
# # {{{ fzf
# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
#
# export FZF_DEFAULT_COMMAND="fd ."
# export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
# export FZF_ALT_C_COMMAND="fd -t d ."
# function fzf-default-opts() {
# 	export FZF_DEFAULT_OPTS="--history=$HOME/.fzf_history"
# 	[ -n "$BASE16_THEME" ] && \
# 		[ -f $HOME/.config/base16-fzf/bash/base16-${BASE16_THEME}.config ] && \
# 			source $HOME/.config/base16-fzf/bash/base16-${BASE16_THEME}.config
# }
# fzf-default-opts
#
# # automatically update BASE16_THEME and fzf colors when base16 theme changes
# function base16_sync() {
# 	SCRIPT=$(readlink -f ~/.base16_theme)
# 	SCRIPT_NAME=${SCRIPT##*/}
# 	THEME_NAME=${SCRIPT_NAME%.*}
# 	THEME=${THEME_NAME#*-}
# 	# if [ "$THEME" != "$BASE16_THEME" ]; then
# 		# echo "old theme: $BASE16_THEME"
# 		export BASE16_THEME=$THEME
# 		# echo "new theme: $BASE16_THEME"
# 		fzf-default-opts
# 	# fi
# }
# add-zsh-hook preexec base16_sync # run command in existing prompt
# add-zsh-hook precmd base16_sync # new prompt line without command
#
# # black or light theme cursor. Not needed any more after switching to kitty
# # $HOME/.config/base16-shell-hooks/modify-cursor-color
# # }}}
#
# export PATH=$HOME/bin:$PATH:$HOME/go/bin
# export EDITOR=nvim
# export LESSKEYIN=~/.config/lesskey
# export PAGER=less
# export PROMPT_COMMAND='history -a'
# export HISTSIZE=100000
# export HISTFILESIZE=200000
# export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
# ## github related
# export GITHUB_TOKEN="${MY_GITHUB_API_TOKEN}"
# export GITHUB_API_TOKEN="${GITHUB_TOKEN}" # for coc-git
# export NPM_TOKEN=${PRIVATE_NPM_TOKEN}
#
# if [ "${OS}" = "Linux" ]; then
# 	alias open="xdg-open"
# 	export PATH=$PATH:$HOME/pycode:$HOME/app/flutter/bin:$HOME/app/android-studio/bin
# 	export PKG_CONFIG_PATH=/usr/lib/x86_64-linux-gnu/pkgconfig:/usr/share/pkgconfig
# fi
#
# if [ "${OS}" = "Darwin" ]; then
# 	if [ -n "${HOMEBREW_PREFIX}" ]; then
# 		# python3 -> python; (DEPRECATED, using pyenv instead)
# 		# use gnu ls etc
# 		# https://formulae.brew.sh/formula/coreutils -> moved to zsh plugin
# 		# https://docs.brew.sh/Homebrew-and-Python#python-3y
# 		# export PATH=$PATH:${HOMEBREW_PREFIX}/opt/python/libexec/bin
# 	fi
# 	alias locate="/usr/bin/locate" # use system locate instead of glocate
# 	# https://github.com/kovidgoyal/kitty/issues/838#issuecomment-770328902
# 	bindkey "\e[1;3D" backward-word # ⌥←
# 	bindkey "\e[1;3C" forward-word # ⌥→
#
# 	# https://github.com/kovidgoyal/kitty/issues/2748#issuecomment-640231667
# 	bindkey '\e[H'  beginning-of-line
# 	bindkey '\e[F'  end-of-line
# 	bindkey '\e[3~' delete-char
# fi
#
# # pyenv {{{
# export PYENV_ROOT="$HOME/.pyenv"
# command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
# # eval "$(pyenv init -)"
# if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi
# # }}}
#
# # alias {{{
# alias cls='echo -ne "\033c"'
# alias rm='rm -i'
# alias dh='dirs -v'
# alias v='nvim'
# alias vi='nvim'
# alias dc='docker-compose'
# alias ns='kubens'
# alias ctx='kubectx'
# alias gs='gst'
# alias lg='lazygit'
# alias l='lf'
# alias gci='git commit'
# # }}}
#
# # familiar bash keybindings {{{
# unsetopt AUTOCD
#
# # Usage: select-word-style word-style
# # where word-style is one of the characters in parentheses:
# # (b)ash:       Word characters are alphanumerics only
# # (n)ormal:     Word characters are alphanumerics plus $WORDCHARS
# # (s)hell:      Words are command arguments using shell syntax
# # (w)hitespace: Words are whitespace-delimited
# # (d)efault:    Use default, no special handling (usually same as `n')
# # (q)uit:       Quit without setting a new style
# # export WORDCHARS='@*?_.[]~=&;!#$%^(){}<>'
# export WORDCHARS='@*?[]~=&!#$%^(){}<>'
# autoload -U select-word-style
# select-word-style bash
#
# # ctrl+u kill to beginning
# bindkey \^U backward-kill-line
#
# # ctrl+w backward kill to space
#
# autoload -U backward-kill-word-match
# zle -N backward-kill-word-space backward-kill-word-match
# zstyle ':zle:backward-kill-word-space' word-style shell
# bindkey '^W' backward-kill-word-space
#
# # alt+delete delete to eol, used cat to show the escape sequence
# bindkey "^[[3;3~" kill-word
# bindkey "^[k" vi-kill-eol # alt+k, also ctrl+alt+k with skhd
# bindkey "^[[76;6u" clear-screen # ctrl+shift+l
#
# # enable bash completion functions
# autoload -U +X bashcompinit && bashcompinit
# # }}}
#
# # lf cd {{{
# lfcd () {
#     tmp="$(mktemp)"
#     # `command` is needed in case `lfcd` is aliased to `lf`
#     command lf -last-dir-path="$tmp" "$@"
#     if [ -f "$tmp" ]; then
#         dir="$(cat "$tmp")"
#         rm -f "$tmp"
#         if [ -d "$dir" ]; then
#             if [ "$dir" != "$(pwd)" ]; then
#                 cd "$dir"
#             fi
#         fi
#     fi
# }
# bindkey -s '^o' 'lfcd\n'  # zsh
# # }}}
# set DISABLE_MAGIC_FUNCTIONS=true
#
# # [ -f ~/.secrets ] && source ~/.secrets
#
#
# # prompt
# eval "$(starship init zsh)"
#
# export JAVA_HOME=$HOME/.jdks/current # managed by intellij
# export PATH="$JAVA_HOME/bin:$PATH"
# export XDG_CONFIG_HOME="$HOME/.config"
#
# ## macos libpq
# if [ "${OS}" = "Darwin" ]; then
# 	export PATH="$HOMEBREW_PREFIX/opt/libpq/bin:$PATH"
# fi
# export PATH="/Users/jackieli/.local/bin:$PATH"
#
# ## yarn global bin
# export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
#
# ## deno
# export PATH="$HOME/.deno/bin:$PATH"
#
# ## flutter
# export PATH=$PATH:$HOME/Applications/flutter/bin
#
# # The next line updates PATH for the Google Cloud SDK.
# if [ -f '/Users/jackieli/Applications/google-cloud-sdk/path.zsh.inc' ]; then
# 	source '/Users/jackieli/Applications/google-cloud-sdk/path.zsh.inc';
# fi
#
# # The next line enables shell command completion for gcloud.
# if [ -f '/Users/jackieli/Applications/google-cloud-sdk/completion.zsh.inc' ]; then
# 	source '/Users/jackieli/Applications/google-cloud-sdk/completion.zsh.inc';
# fi
#
# # bun completions
# [ -s "/Users/jackieli/.bun/_bun" ] && source "/Users/jackieli/.bun/_bun"
#
# ## ruby gems
# export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
# export GEM_HOME=$HOME/.gem
# export PATH=$GEM_HOME/bin:$GEM_HOME/ruby/3.2.0/bin:$PATH
#
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
