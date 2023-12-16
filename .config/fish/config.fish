# set -x fish_trace 1
# set -x FISH_DEBUG env-export
# set -x FISH_DEBUG_OUTPUT /tmp/fish-debug.log

/opt/homebrew/bin/brew shellenv | source

set -Ux EDITOR (which nvim)
set -Ux VISUAL $EDITOR
set -Ux SUDO_EDITOR $EDITOR
set -Ux LESSKEYIN ~/.config/lesskey
set -Ux PAGER less

fish_add_path ~/bin ~/pycode

# Go
set -Ux GOPATH ~/go
fish_add_path $GOPATH/bin

source ~/.secrets

# this enables `use node` in direnv
set -Ux NODE_VERSION_PREFIX
set -Ux NODE_VERSIONS ~/.nvm/versions/node

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

if status is-interactive
  set -g fish_greeting

	abbr vi nvim
	abbr v nvim
	abbr rm grm -I
	abbr dc docker-compose
	abbr ns kubens
	abbr ctx kubectx
	abbr gs gst
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

  starship init fish | source
  zoxide init fish | source
  direnv hook fish | source

	bind \cx\ce edit_command_buffer # ctrl+x ctrl+e to edit command buffer
	bind \cH backward-kill-path-component # ctrl+backspace to delete path component
	bind \cw backward-kill-bigword # ctrl+w to delete big word
	bind \e\[3\;5~ kill-word # ctrl+delete to delete forward word

	fish_add_path ~/.fzf/bin
	set -Ux FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'
	set -Ux FZF_DEFAULT_OPTS "--history=$HOME/.fzf_history --bind='ctrl-e:preview-down,ctrl-y:preview-up,ctrl-o:toggle-preview'"
	# if [ -n "$BASE16_THEME" ] && [ -f ~/.config/base16-fzf/fish/base16-$BASE16_THEME.fish ] && not string match -qe -- --color $FZF_DEFAULT_OPTS
	# 	source ~/.config/base16-fzf/fish/base16-$BASE16_THEME.fish
	# end

	# brew install coreutils findutils gnu-tar gnu-sed gawk gnutls gnu-indent gnu-getopt grep
  set OS (uname -s)
	if [ "$OS" = "Darwin" ]
		# alias ls "ls -G"
		alias sed gsed
		alias df gdf
		alias cp gcp
	end

	function base16-helper
		set BASE16_SHELL "$HOME/.config/base16-shell/"
		source "$BASE16_SHELL/profile_helper.fish"
	end

	abbr lv "NVIM_APPNAME=lazyvim nvim"
	abbr nvim_old "NVIM_APPNAME=nvim_old nvim"

end

# vim:set noet sts=-1 sw=2 ts=2:
