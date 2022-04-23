# Brew file for linux and mac

# Basics {{{
cask "kitty"
brew "tmux"
brew "neovim"
brew "fd"
brew "starship"
brew "zoxide" # z change directory
brew "gh"
brew "lazygit"
brew "jq"
brew "node"
brew "yarn"
brew "python3"
brew "tree"
brew "htop"

brew "git-remote-gcrypt" # for encrypted repo
brew "golang"

# }}}

# Mac {{{
if OS.mac?
    tap "koekeishiya/formulae"
    # see https://github.com/koekeishiya/yabai for installation steps on mac
    brew "koekeishiya/formulae/yabai" # window manager
    brew "koekeishiya/formulae/skhd" # shortcuts
    cask "mouse-fix" # mouse scrolling fix & button remap
    brew "bash" # need newest bash for some program like extracto
    cask "google-chrome" # TODO: check if installed
    cask "homebrew/cask-fonts/font-fira-code-nerd-font"
else
    # linux ones
end
# }}}


# ( vim: set ts=4 sw=4 et fdm=marker: )
