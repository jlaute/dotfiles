#!/bin/bash

mkdir -p "$XDG_CONFIG_HOME/nvim"
mkdir -p "$XDG_CONFIG_HOME/nvim/undo"
ln -sf "$DOTFILES/wsl2/nvim/init.lua" "$XDG_CONFIG_HOME/nvim"
rsync -a "$DOTFILES/wsl2/nvim/lua" "$XDG_CONFIG_HOME/nvim"
rsync -a "$DOTFILES/wsl2/nvim/myplugins" "$XDG_CONFIG_HOME/nvim"

# Install (or update) all the plugins
# nvim --noplugin +PackerInstall +qa

mkdir -p "$XDG_CONFIG_HOME/zsh"
ln -sf "$DOTFILES/wsl2/zsh/.zshenv" "$HOME"
ln -sf "$DOTFILES/wsl2/zsh/.zshrc" "$XDG_CONFIG_HOME/zsh"
ln -sf "$DOTFILES/wsl2/zsh/aliases" "$XDG_CONFIG_HOME/zsh/aliases"

rm -rf "$XDG_CONFIG_HOME/zsh/external"
ln -sf "$DOTFILES/wsl2/zsh/external" "$XDG_CONFIG_HOME/zsh"

########
# tmux #
########

mkdir -p "$XDG_CONFIG_HOME/tmux"
ln -sf "$DOTFILES/wsl2/tmux/tmux.conf" "$XDG_CONFIG_HOME/tmux/tmux.conf"
if [ ! -d "$XDG_CONFIG_HOME/tmux/plugins/tpm" ]; then
    git clone git@github.com:tmux-plugins/tpm.git $XDG_CONFIG_HOME/tmux/plugins/tpm
fi


mkdir -p "$XDG_CONFIG_HOME/phpactor"
ln -sf "$DOTFILES/wsl2/phpactor/phpactor.json" "$XDG_CONFIG_HOME/phpactor/phpactor.json"
