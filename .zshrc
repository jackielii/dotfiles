# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
  export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"
# ZSH_THEME="agnoster"

DEFAULT_USER="jackieli"

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.

VIM_MODE_NO_DEFAULT_BINDINGS=true

plugins=(
  git
  kubectl
  golang
  tmux
  zsh-autosuggestions
  docker
  docker-compose
  # # zsh-vim-mode
  you-should-use
  gh
)

if [ -d ~/.ssh ] && [ -f ~/.ssh/id_rsa ]; then
  plugins=(ssh-agent $plugins)
  zstyle :omz:plugins:ssh-agent identities id_tes_ed25519 id_rsa
fi

source $ZSH/oh-my-zsh.sh

# User configuration

[ -z "${HOMEBREW_PREFIX}" ] && eval "$(brew shellenv)"

# When logging in from tty .profile will not be sourced because we use zsh as
# login shell: https://gist.github.com/pbrisbin/45654dc74787c18e858c However,
# when logging in via UI, .profile will be sourced:
# https://github.com/canonical/lightdm/blob/1.26.0/debian/lightdm-session#L38
# We put the env vars in .profile because we need the PATH etc to be present
# for GUI apps. If we source .profile in .zshrc directly, it'll be sourced
# twice when the tty emulator starts which calls zsh which will eval .zshrc.
# Hense the following line
[[ $_DOT_PROFILE_SOURCED != "yes" && -f ~/.profile ]] && source ~/.profile

eval "$(direnv hook zsh)"

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# {{{ editing mode e=emacs v=vim
# export KEYTIMEOUT=1
# bindkey -v

# ## more keys for easier editing: best of emacs & vim
# bindkey "^a" beginning-of-line
# bindkey "^e" end-of-line
# bindkey "^f" history-incremental-search-forward
# bindkey "^g" send-break
# bindkey "^h" backward-delete-char
# bindkey "^n" down-history
# bindkey "^p" up-history
# bindkey "^r" history-incremental-search-backward
# bindkey "^u" redo
# bindkey "^w" backward-kill-word
# bindkey "^?" backward-delete-char
# bindkey -M viins '^[.' insert-last-word
# backward-kill-dir () {
#     local WORDCHARS=${WORDCHARS/\/}
#     zle backward-kill-word
# }
# zle -N backward-kill-dir
# bindkey '^[^?' backward-kill-dir
# bindkey "^[[1;3C" forward-word
# bindkey "^[[1;3D" backward-word
# }}} vim+emacs mode

# {{{ nvm.sh
# the original load nvm is very slow, load manually
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# Install zsh-async if it’s not present
# if [[ ! -a ~/.zsh-async ]]; then
#   git clone git@github.com:mafredri/zsh-async.git ~/.zsh-async
# fi
# source ~/.zsh-async/async.zsh
# export NVM_DIR="$HOME/.nvm"
# function load_nvm() {
#     [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
#     [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
# }
# async_start_worker nvm_worker -n
# async_register_callback nvm_worker load_nvm
# async_job nvm_worker sleep 0.1

# alternative
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" --no-use # This loads nvm
# alias node='unalias node ; unalias npm ; nvm use default ; node $@'
# alias npm='unalias node ; unalias npm ; nvm use default ; npm $@'
# alias loadnvm="source $NVM_DIR/nvm.sh"
# }}}
#

# {{{ zoxide zsh-z alternative
# https://github.com/ajeetdsouza/zoxide
eval "$(zoxide init zsh)"
# }}}

# Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        eval "$("$BASE16_SHELL/profile_helper.sh")"

# {{{ fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# export FZF_TMUX=1
# export FZF_TMUX_OPTS="-p60%,70%"

export FZF_DEFAULT_COMMAND="fd . $HOME"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd -t d . $HOME"
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --history=$HOME/.fzf_history"

# Base16 fzf
[ -n "$BASE16_THEME" ] && \
	[ -f $HOME/.config/base16-fzf/bash/base16-${BASE16_THEME}.config ] && \
	source $HOME/.config/base16-fzf/bash/base16-${BASE16_THEME}.config

 # }}}

export PATH=$HOME/bin:$PATH:$HOME/go/bin:$HOME/pycode:$HOME/app/flutter/bin:$HOME/app/android-studio/bin
export EDITOR=nvim
export PAGER=less
export PROMPT_COMMAND='history -a'
export HISTSIZE=100000
export HISTFILESIZE=2000000
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
export PKG_CONFIG_PATH=/usr/lib/x86_64-linux-gnu/pkgconfig:/usr/share/pkgconfig

OS=$(uname -s)

if [ "${OS}" = "Linux" ]; then
  alias open="xdg-open"
fi

alias cls='echo -ne "\033c"'
alias rm='rm -i'
alias dh='dirs -v'
alias v='nvim'
alias vi='nvim'
alias dc='docker-compose'

unsetopt AUTOCD
# ctrl+u kill to beginning
autoload -U select-word-style
# select-word-style bash
bindkey \^U backward-kill-line
export WORDCHARS='@*?_.[]~=&;!#$%^(){}<>'

# ctrl+w backward kill to space
autoload -U backward-kill-word-match
zle -N backward-kill-word-space backward-kill-word-match
zstyle ':zle:backward-kill-word-space' word-style space
bindkey '^W' backward-kill-word-space
# alt+delete delete to eol, used cat to show the escape sequence
bindkey "^[[3;3~" vi-kill-eol

[ -f ~/.secrets ] && source ~/.secrets

export GPG_TTY=$(tty)
export GO111MODULE=on

# enable bash completion functions
autoload -U +X bashcompinit && bashcompinit
alias gci='git commit'
eval "$(starship init zsh)"

alias ns='kubens'
alias ctx='kubectx'
alias gs='gst'
alias lg='lazygit'
unalias gops

export JAVA_HOME=$HOME/.jdks/current # managed by intellij
export PATH="$JAVA_HOME/bin:$PATH"
