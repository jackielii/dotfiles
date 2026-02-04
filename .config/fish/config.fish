# set -x fish_trace 1
# set -x FISH_DEBUG env-export
# set -x FISH_DEBUG_OUTPUT /tmp/fish-debug.log

/opt/homebrew/bin/brew shellenv | source

fish_add_path "/Users/jackieli/.bun/bin"
fish_add_path -m ~/.local/bin
fish_add_path -m ~/bin ~/pycode

# Go
set -Ux GOPATH ~/go
fish_add_path -m $GOPATH/bin

set -Ux EDITOR (which nvim)
set -Ux VISUAL $EDITOR
set -Ux SUDO_EDITOR $EDITOR
set -Ux LESSKEYIN ~/.config/lesskey
# pager is set in ~/.config/kitty/kitty.conf
set -Ux PAGER less

source ~/.secrets

# this enables `use node` in direnv
set -Ux NODE_VERSION_PREFIX
set -Ux NODE_VERSIONS ~/.nvm/versions/node

set -Ux GITHUB_TOKEN $MY_GITHUB_API_TOKEN
# set -Ux GITHUB_COPILOT_TOKEN $MY_GITHUB_API_TOKEN

# here we disable the loading of base16-shell. To change the theme:
# 1. load_base16_helper
# 2. base16-decaf
# 3. restart everything
# explaination:
# when login, we make sure BASE16_THEME is set to the theme that's linked to ~/.base16_theme
# kitty would load the theme by including $KITTY_CONFIG/base16-kitty/colors/base16-${BASE16_THEME}-256.conf
# neovim would check $BASE16_THEME and load colorscheme base16-${BASE16_THEME}
if [ -z "$BASE16_THEME" ] && [ -e ~/.base16_theme ]
    set -l SCRIPT_NAME (basename (realpath ~/.base16_theme) .sh)
    set -gx BASE16_THEME (string match 'base16-*' $SCRIPT_NAME  | string sub -s (string length 'base16-*'))
end

set -Ux XDG_CONFIG_HOME "$HOME/.config"

fish_add_path ~/.fzf/bin
fish_add_path ~/.cargo/bin

if status is-interactive
    set -g fish_greeting

    abbr vi nvim
    abbr v nvim
    abbr rm grm -I
    abbr dc docker-compose
    abbr ns kubens
    abbr ctx kubectx
    abbr gs git status
    abbr lg lazygit
    abbr l lf
    abbr gci git commit
    abbr k kubectl
    abbr d kitten diff
    abbr gd git difftool --no-symlinks --dir-diff
    abbr gds git difftool --no-symlinks --dir-diff --staged
    abbr gsh git difftool --no-symlinks --dir-diff HEAD~1 HEAD
    abbr gr8 git rev-parse --short=8 HEAD
    abbr gcm git checkout (__git.default_branch)
    abbr gcim git commit -m
    abbr glola git log --oneline --decorate --color --graph --all
    abbr - cd -
    abbr dcps docker-compose ps
    abbr dcupd docker-compose up -d
    abbr dcup docker-compose up
    abbr dcdn docker-compose down
    abbr ll ls -lhtr
    abbr ly lazygit -ucd ~/.local/share/yadm/lazygit -w ~ -g ~/.local/share/yadm/repo.git

    starship init fish | source
    # oh-my-posh init fish | source
    zoxide init fish | source
    direnv hook fish | source


    bind \cx\ce edit_command_buffer # ctrl+x ctrl+e to edit command buffer
    bind \cH backward-kill-path-component # ctrl+backspace to delete path component
    bind \cw backward-kill-bigword # ctrl+w to delete big word
    bind \e\[3\;5~ kill-word # ctrl+delete to delete forward word

    set -Ux FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'
    set -Ux FZF_DEFAULT_OPTS "--history=$HOME/.fzf_history --bind='ctrl-e:preview-down,ctrl-y:preview-up,ctrl-o:toggle-preview'"
    # if [ -n "$BASE16_THEME" ] && [ -f ~/.config/base16-fzf/fish/base16-$BASE16_THEME.fish ] && not string match -qe -- --color $FZF_DEFAULT_OPTS
    # 	source ~/.config/base16-fzf/fish/base16-$BASE16_THEME.fish
    # end

    # brew install coreutils findutils gnu-tar gnu-sed gawk gnutls gnu-indent gnu-getopt grep
    set -l OS (uname -s)
    if [ "$OS" = Darwin ]
        # alias ls "ls -G"
        alias sed gsed
        alias df gdf
        alias cp gcp
    end

    function base16-helper
        set BASE16_SHELL "$HOME/.config/base16-shell/"
        source "$BASE16_SHELL/profile_helper.fish"
    end

    function mkcd
        mkdir -pv $argv
        cd $argv
    end

    abbr lv "NVIM_APPNAME=lazyvim nvim"
    abbr nvim_old "NVIM_APPNAME=nvim_old nvim"

    if [ -n "$KITTY_PID" ]
        abbr ks "kitten ssh"
    end

    alias pg $PAGER
    if [ -f ~/.local/share/google-cloud-sdk/path.fish.inc ]
        . ~/.local/share/google-cloud-sdk/path.fish.inc
    end

    fish_add_path /opt/homebrew/opt/coreutils/libexec/gnubin
end

# vim:set et sts=4 sw=4 ts=4:
