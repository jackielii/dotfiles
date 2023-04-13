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
brew "node@16", link: true # Copilot requires node@16 on macos
brew "yarn"
brew "python3"
brew "tree"
brew "htop"
brew "rg"
brew "git-remote-gcrypt" # for encrypted repo
brew "golang"
brew "gron"
brew "direnv"
brew "ranger"
brew "kubectl"
brew "envoy"
brew "tig"
brew "imagemagick"
brew "bufbuild/buf/buf"
brew "tctl"
brew "kubectx"
brew "git-lfs"
brew "libpq"

brew "ccls" # C/C++/Objective-C language server
# }}}

# Mac {{{
if OS.mac?
# gnu utils {{{
    brew "coreutils"
    brew "findutils"
    brew "gnu-indent"
    brew "gnu-sed"
    brew "gnutls"
    brew "grep"
    brew "gnu-tar"
    brew "gawk"
# }}}

    tap "koekeishiya/formulae"
    # see https://github.com/koekeishiya/yabai for installation steps on mac
    brew "koekeishiya/formulae/yabai", restart_service: :changed # window manager
    brew "koekeishiya/formulae/skhd", restart_service: :changed # shortcuts
    cask "mouse-fix" # mouse scrolling fix & button remap
    brew "bash" # need newest bash for some program like extracto
    cask "google-chrome" # TODO: check if installed
    cask "homebrew/cask-fonts/font-fira-code-nerd-font"
    cask "homebrew/cask-fonts/font-cascadia-code"
    cask "homebrew/cask-fonts/font-symbols-only-nerd-font"
    # cask "karabiner-elements"
    cask "maccy" # clipboard manager
    cask "intellij-idea-ce"
    cask "xbar"
    brew "cliclick" # automate mouse clicks
    cask "gimp"
    cask "drawio"
    cask "alt-tab"
else
    # linux ones
end
# }}}

## Examples
# # 'brew tap'
# tap "homebrew/cask"
# # 'brew tap' with custom Git URL
# tap "user/tap-repo", "https://user@bitbucket.org/user/homebrew-tap-repo.git"
# # set arguments for all 'brew install --cask' commands
# cask_args appdir: "~/Applications", require_sha: true
#
# # 'brew install'
# brew "imagemagick"
# # 'brew install --with-rmtp', 'brew services restart' on version changes
# brew "denji/nginx/nginx-full", args: ["with-rmtp"], restart_service: :changed
# # 'brew install', always 'brew services restart', 'brew link', 'brew unlink mysql' (if it is installed)
# brew "mysql@5.6", restart_service: true, link: true, conflicts_with: ["mysql"]
#
# # 'brew install --cask'
# cask "google-chrome"
# # 'brew install --cask --appdir=~/my-apps/Applications'
# cask "firefox", args: { appdir: "~/my-apps/Applications" }
# # always upgrade auto-updated or unversioned cask to latest version even if already installed
# cask "opera", greedy: true
# # 'brew install --cask' only if '/usr/libexec/java_home --failfast' fails
# cask "java" unless system "/usr/libexec/java_home --failfast"
#
# # 'mas install'
# mas "1Password", id: 443987910
#
# # 'whalebrew install'
# whalebrew "whalebrew/wget"

# ( vim: set ts=4 sw=4 et fdm=marker: )
