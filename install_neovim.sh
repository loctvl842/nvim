#!/bin/bash

git clone https://github.com/neovim/neovim.git ~/.config/nvim/neovim

cd ~/.config/nvim/neovim

# [latest] Nvim release build
git reset --hard 040f1459849ab05b04f6bb1e77b3def16b4c2f2b

sudo rm /usr/local/bin/nvim
sudo rm -r /usr/local/share/nvim/

make CMAKE_BUILD_TYPE=RelWithDebInfo

sudo make install

sudo rm -rf ~/.config/nvim/neovim
