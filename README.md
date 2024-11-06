# My dot files

Managed via [yadm](https://yadm.io/)

## Install

```
bash -c "$(curl -fsSL https://jackieli.dev/dot)"
```

Or 

```sh
#!/bin/bash
set -e

# Install using (don't run as root):
# /bin/bash -c "$(curl -fsSL https://jackieli.dev/dot)"

# Ask for the administrator password upfront
echo "Authenticate sudo for brew & settings"
sudo -v
# Keep-alive: update existing `sudo` time stamp until bootstrapping has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo "Installing homebrew"
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install yadm gpg

echo "Cloning jackielii/dotfiles"
yadm clone https://github.com/jackielii/dotfiles.git --bootstrap
```

## Mac

- yabai
- skhd
- kitty
- neovim
- lf
