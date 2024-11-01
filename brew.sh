# init brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo eval $(/opt/homebrew/bin/brew shellenv) >> ~/.zprofile
eval $(/opt/homebrew/bin/brew shellenv)

brew install --cask --no-quarantine middleclick
brew install --cask alacritty
brew install --cask alt-tab

# Font
brew install --cask font-fira-code-nerd-font
brew install --cask font-sauce-code-pro-nerd-font
# Version management
brew install asdf
# Quick switch directory
brew install autojump
# Code highlight
brew install bat
# Utilities
brew install coreutils curl git
brew install csvkit
brew install fzf
brew install gcc readline zlib curl ossp-uuid icu4c pkg-config
brew install hub
brew install jless
brew install pango
brew install pkg-config cairo pango libpng jpeg giflib librsvg
brew install python-setuptools
brew install ripgrep fd
brew install the_silver_searcher
brew install libpq shared-mime-info imagemagick@6
brew install jq
