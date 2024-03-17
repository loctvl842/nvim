nixCatsBuilds: inputs: let
  overlay = self: super: {
    nixCatsBuilds = {
      neovim-session-manager = self.fetchFromGitHub {
        owner = "Shatur";
        repo = "neovim-session-manager";
        rev = "d8e1ba3bbcf3fdc6a887bcfbd94c48ae4707b457";
        hash = "sha256-+TDWY8mprJfUp9ZFKbz83to7XW8iiovja22jHms+N1A=";
      };
      neovim-project = self.fetchFromGitHub {
        owner = "coffebar";
        repo = "neovim-project";
        rev = "d7a91b6b86f3b5ff2d47c2ef920bc362e581ac48";
        hash = "sha256-nnzMuZMWJtKCgz8e3Bnz+9EJ6LSvBI7Unb56DrUJkIs=";
      };
      icon-picker-nvim = self.fetchFromGitHub {
        owner = "ziontee113";
        repo = "icon-picker.nvim";
        rev = "3ee9a0ea9feeef08ae35e40c8be6a2fa2c20f2d3";
        hash = "sha256-VZKsVeSmPR3AA8267Mtd5sSTZl2CAqnbgqceCptgp4w=";
      };
      mini-indentscope = self.fetchFromGitHub {
        owner = "echasnovski";
        repo = "mini.indentscope";
        rev = "cf07f19e718ebb0bcc5b00999083ce11c37b8d40";
        hash = "sha256-osHzjhCqjR3i722CX70tZnEArMCYLi/0BHCjg3RXMkM=";
      };
    };
  };
in
overlay
