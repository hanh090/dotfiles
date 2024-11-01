# required
brew install asdf
# Nodejs
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf install nodejs 18
asdf list nodejs
asdf list all nodejs
asdf install nodejs 18.20.4
asdf install nodejs 22.4.0
asdf global nodejs 18.20.4
asdf reshim nodejs

# Neovim
asdf plugin add neovim
asdf install neovim stable
asdf global nvim stable


# Ruby
asdf plugin-add ruby
asdf install ruby 3.2.0
asdf install ruby 2.7.8

# Tmux
asdf plugin-add tmux https://github.com/aphecetche/asdf-tmux.git
asdf list all tmux
asdf install tmux 3.5
asdf global tmux 3.5
asdf reshim tmux

# Python
asdf plugin-add python
asdf install python 3.12.6
asdf install python 3.5.10
asdf global python 3.12.6
asdf list python

# Postgres
asdf plugin-add postgres
asdf install postgres 13.3
asdf global postgres 13.3
