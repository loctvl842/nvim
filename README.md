# 🦁 BeastVim

*My Beast*

**nvim v0.9.5**

## Installation

Running the following script if you want to install Neovim at a specific version:

```sh
~/.config/nvim/install-nvim.sh
```

![image](https://github.com/loctvl842/tvl-library/assets/80513079/3771ae81-50bf-4b6a-8b5c-a9ec44bc6e6f)

## 🛠️ Prerequisites

Before setting up this Neovim configuration, ensure that the following dependencies are installed on your system:

- [ripgrep](https://github.com/BurntSushi/ripgrep)
- [xclip](https://github.com/astrand/xclip)
- [unzip](https://linux.die.net/man/1/unzip) (Required for installing language packs)
- [npm (node)](https://www.npmjs.com/get-npm)
- [pass](https://www.passwordstore.org/)

You can install these dependencies on Arch Linux using the following command:

```sh
sudo pacman -S ripgrep xclip unzip npm pass
```

### ⚙️ Terminal

This Neovim configuration is designed to work seamlessly with the [Kitty terminal emulator](https://sw.kovidgoyal.net/kitty/). For optimal visual results, it is recommended to use the Nerd Font with fixed underline. Add the following configuration to your Kitty terminal settings:

```conf
modify_font                     strikethrough_position 130%
modify_font                     strikethrough_thickness 0.1px
modify_font                     underline_position 150%
modify_font                     underline_thickness 0.1px
modify_font                     cell_height 305%
```
