# Copyright (c) 2023 BirdeeHub
# Licensed under the MIT license

# This is an empty nixCats config.
# you may import this template directly into your nvim folder
# and then add plugins to categories here,
# and call the plugins with their default functions
# within your lua, rather than through the nvim package manager's method.
# Use the help, and the example repository https://github.com/BirdeeHub/nixCats-nvim

# It allows for easy adoption of nix,
# while still providing all the extra nix features immediately.
# Configure in lua, check for a few categories, set a few settings,
# output packages with combinations of those categories and settings.

# All the same options you make here will be automatically exported in a form available
# in home manager and in nixosModules, as well as from other flakes.
# each section is tagged with its relevant help section.

{
  description = "A Lua-natic's neovim flake, with extra cats! nixCats!";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";
    nixCats.inputs.nixpkgs.follows = "nixpkgs";
    nixCats.inputs.flake-utils.follows = "flake-utils";
    # for if you wish to select a particular neovim version
    # neovim = {
    #   url = "github:neovim/neovim/nightly";
    #   flake = false;
    # };
    # add this input to the nvimSRC attribute of the settings set later in this file.

    # see :help nixCats.flake.inputs
    # If you want your plugin to be loaded by the standard overlay,
    # i.e. if it wasnt on nixpkgs, but doesnt have an extra build step.
    # Then you should name it "plugins-something"
    # If you wish to define a custom build step not handled by nixpkgs,
    # then you should name it in a different format, and deal with that in the
    # overlay defined for custom builds in the overlays directory.
    # for specific tags, branches and commits, see:
    # https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake.html#examples

  };

  # see :help nixCats.flake.outputs
  outputs = { self, nixpkgs, flake-utils, nixCats, ... }@inputs: let
    inherit (nixCats) utils;
    luaPath = "${./.}";
    forEachSystem = flake-utils.lib.eachSystem flake-utils.lib.allSystems;
    # the following extra_pkg_config contains any values
    # which you want to pass to the config set of nixpkgs
    # import nixpkgs { config = extra_pkg_config; inherit system; }
    # will not apply to module imports
    # as that will have your system values
    extra_pkg_config = {
      allowUnfree = true;
    };
    # sometimes our overlays require a ${system} to access the overlay.
    # management of this variable is one of the harder parts of using flakes.

    # so I have done it here in an interesting way to keep it out of the way.

    # First, we will define just our overlays per system.
    # later we will pass them into the builder, and the resulting pkgs set
    # will get passed to the categoryDefinitions and packageDefinitions
    # which follow this section.

    # this allows you to use ${pkgs.system} whenever you want in those sections
    # without fear.
    system_resolved = forEachSystem (system: let
      # see :help nixCats.flake.outputs.overlays
      standardPluginOverlay = utils.standardPluginOverlay;
      dependencyOverlays = (import ./overlays inputs) ++ [
        # This overlay grabs all the inputs named in the format
        # `plugins-<pluginName>`
        # Once we add this overlay to our nixpkgs, we are able to
        # use `pkgs.neovimPlugins`, which is a set of our plugins.
        (standardPluginOverlay inputs)
        # add any flake overlays here.
      ];
      # these overlays will be wrapped with ${system}
      # and we will call the same flake-utils function
      # later on to access them.
    in { inherit dependencyOverlays; });
    inherit (system_resolved) dependencyOverlays;
    # see :help nixCats.flake.outputs.categories
    # and
    # :help nixCats.flake.outputs.categoryDefinitions.scheme
    categoryDefinitions = { pkgs, settings, categories, name, ... }@packageDef: {
      # to define and use a new category, simply add a new list to a set here,
      # and later, you will include categoryname = true; in the set you
      # provide when you build the package using this builder function.
      # see :help nixCats.flake.outputs.packageDefinitions for info on that section.

      # propagatedBuildInputs:
      # this section is for dependencies that should be available
      # at BUILD TIME for plugins. WILL NOT be available to PATH
      # However, they WILL be available to the shell
      # and neovim path when using nix develop
      propagatedBuildInputs = {
        generalBuildInputs = with pkgs; [
          deno
          yarn
        ];
      };

      # lspsAndRuntimeDeps:
      # this section is for dependencies that should be available
      # at RUN TIME for plugins. Will be available to PATH within neovim terminal
      # this includes LSPs
      lspsAndRuntimeDeps = {
        general = with pkgs; [
          deno
        ];
      };

      # This is for plugins that will load at startup without using packadd:
      startupPlugins = {
        general = with pkgs.nixCatsBuilds; [
          pkgs.vimPlugins.plenary-nvim
          pkgs.vimPlugins.nui-nvim
          pkgs.vimPlugins.vim-startuptime
        ];
        coding = with pkgs.nixCatsBuilds; [
          # Snippets
          pkgs.vimPlugins.luasnip
          pkgs.vimPlugins.friendly-snippets
          # Vim Motion
          pkgs.vimPlugins.vim-surround
          # Completion
          pkgs.vimPlugins.nvim-cmp
          pkgs.vimPlugins.nvim-jdtls
          pkgs.vimPlugins.cmp-nvim-lsp
          pkgs.vimPlugins.cmp-buffer
          pkgs.vimPlugins.cmp-path
          pkgs.vimPlugins.cmp-cmdline
          pkgs.vimPlugins.cmp_luasnip
          # Git Workflow
          pkgs.vimPlugins.neogit
          # Comments
          pkgs.vimPlugins.nvim-ts-context-commentstring
          pkgs.vimPlugins.comment-nvim
          # Testing
          pkgs.vimPlugins.neotest
          pkgs.vimPlugins.neotest-go
          pkgs.vimPlugins.neotest-rspec
          pkgs.vimPlugins.neotest-vitest
        ];
        colorscheme = with pkgs.nixCatsBuilds; [
          pkgs.vimPlugins.catppuccin-nvim
        ];
        editor = with pkgs.nixCatsBuilds; [
          # File Navigation
          pkgs.vimPlugins.neo-tree-nvim
          # Fuzzy Search
          pkgs.vimPlugins.telescope-nvim
          # Core Utils
          pkgs.vimPlugins.which-key-nvim
          pkgs.vimPlugins.gitsigns-nvim
          pkgs.vimPlugins.vim-illuminate
          pkgs.vimPlugins.statuscol-nvim
          pkgs.vimPlugins.FixCursorHold-nvim
          pkgs.vimPlugins.trouble-nvim
          # Project Management
          neovim-session-manager
          neovim-project
          # Buffer Folding
          pkgs.vimPlugins.nvim-ufo
          pkgs.vimPlugins.promise-async
          pkgs.vimPlugins.nvim-lastplace
        ];
        lsp = with pkgs.nixCatsBuilds; [
          # LSP
          pkgs.vimPlugins.neodev-nvim
          pkgs.vimPlugins.nvim-lspconfig
          # Debugging
          pkgs.vimPlugins.nvim-dap
          # Formatters
          pkgs.vimPlugins.null-ls-nvim
          # Inlay Hints
          pkgs.vimPlugins.lsp-inlayhints-nvim
          pkgs.vimPlugins.lsp_signature-nvim
        ];
        settings = with pkgs.nixCatsBuilds; [ ];
        tools = with pkgs.nixCatsBuilds; [
          pkgs.vimPlugins.vim-visual-multi
          pkgs.vimPlugins.markdown-preview-nvim
          pkgs.vimPlugins.vim-bbye
          pkgs.vimPlugins.toggleterm-nvim
          icon-picker-nvim
        ];
        treesitter = with pkgs.nixCatsBuilds; [
          pkgs.vimPlugins.nvim-treesitter
          pkgs.vimPlugins.rainbow-delimiters-nvim
          pkgs.vimPlugins.nvim-ts-autotag
          pkgs.vimPlugins.vim-helm
        ];
        ui = with pkgs.nixCatsBuilds; [
          # Notifications
          pkgs.vimPlugins.nvim-notify
          # Buffer Management
          pkgs.vimPlugins.bufferline-nvim
          pkgs.vimPlugins.nvim-web-devicons
          # Status Line
          pkgs.vimPlugins.lualine-nvim
          # Util/Rice
          mini-indentscope
          pkgs.vimPlugins.barbecue-nvim
          pkgs.vimPlugins.dashboard-nvim
          pkgs.vimPlugins.nvim-scrollbar
          pkgs.vimPlugins.windows-nvim
          pkgs.vimPlugins.nvim-colorizer-lua
          pkgs.vimPlugins.dressing-nvim
          pkgs.vimPlugins.noice-nvim
        ];
        util = with pkgs.nixCatsBuilds; [ ];
      };

      # not loaded automatically at startup.
      # use with packadd and an autocommand in config to achieve lazy loading
      optionalPlugins = {
        general = with pkgs.nixCatsBuilds; [ ];
        coding = with pkgs.nixCatsBuilds; [
        ];
        colorscheme = with pkgs.nixCatsBuilds; [ ];
        editor = with pkgs.nixCatsBuilds; [ ];
        lsp = with pkgs.nixCatsBuilds; [
        ];
        settings = with pkgs.nixCatsBuilds; [ ];
        tools = with pkgs.nixCatsBuilds; [ ];
        treesitter = with pkgs.nixCatsBuilds; [ ];
        ui = with pkgs.nixCatsBuilds; [ ];
        util = with pkgs.nixCatsBuilds; [ ];
      };

      # environmentVariables:
      # this section is for environmentVariables that should be available
      # at RUN TIME for plugins. Will be available to path within neovim terminal
      environmentVariables = {
        test = {
          CATTESTVAR = "It worked!";
        };
      };

      # If you know what these are, you can provide custom ones by category here.
      # If you dont, check this link out:
      # https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/make-wrapper.sh
      extraWrapperArgs = {
        test = [
          '' --set CATTESTVAR2 "It worked again!"''
        ];
      };

      # lists of the functions you would have passed to
      # python.withPackages or lua.withPackages

      # get the path to this python environment
      # in your lua config via
      # vim.g.python3_host_prog
      # or run from nvim terminal via :!nvim-python3
      extraPython3Packages = {
        test = (_:[]);
      };
      extraPythonPackages = {
        test = (_:[]);
      };
      # populates $LUA_PATH and $LUA_CPATH
      extraLuaPackages = {
        test = [ (_:[]) ];
      };
    };



    # And then build a package with specific categories from above here:
    # All categories you wish to include must be marked true,
    # but false may be omitted.
    # This entire set is also passed to nixCats for querying within the lua.

    # see :help nixCats.flake.outputs.packageDefinitions
    packageDefinitions = {
      # These are the names of your packages
      # you can include as many as you wish.
      nixCats = {pkgs , ... }: {
        # they contain a settings set defined above
        # see :help nixCats.flake.outputs.settings
        settings = {
          wrapRc = false;
          # IMPORTANT:
          # you may not alias to nvim
          # your alias may not conflict with your other packages.
          aliases = [ "vim" ];
          # nvimSRC = inputs.neovim;
          withNodeJs = true;
          withRuby = true;
          withPython3 = true;
        };

        options = {
          colorscheme = "catppuccin";
        };
        # and a set of categories that you want
        # (and other information to pass to lua)
        categories = {
          general = true;
          coding = true;
          colorscheme = true;
          editor = true;
          lsp = true;
          settings = true;
          tools = true;
          treesitter = true;
          ui = true;
          util = true;
        };
      };
    };
  # In this section, the main thing you will need to do is change the default package name
  # to the name of the packageDefinitions entry you wish to use as the default.
    defaultPackageName = "nixCats";
  in


  # see :help nixCats.flake.outputs.exports
  forEachSystem (system: let
    inherit (utils) baseBuilder;
    customPackager = baseBuilder luaPath {
      inherit nixpkgs system dependencyOverlays extra_pkg_config;
    } categoryDefinitions;
    nixCatsBuilder = customPackager packageDefinitions;
    # this is just for using utils such as pkgs.mkShell
    # The one used to build neovim is resolved inside the builder
    # and is passed to our categoryDefinitions and packageDefinitions
    pkgs = import nixpkgs { inherit system; };
  in
  {
    # these outputs will be wrapped with ${system} by flake-utils.lib.eachDefaultSystem

    # this will make a package out of each of the packageDefinitions defined above
    # and set the default package to the one named here.
    packages = utils.mkPackages nixCatsBuilder packageDefinitions defaultPackageName;

    # this will make an overlay out of each of the packageDefinitions defined above
    # and set the default overlay to the one named here.
    overlays = utils.mkOverlays nixCatsBuilder packageDefinitions defaultPackageName;

    # choose your package for devShell
    # and add whatever else you want in it.
    devShell = pkgs.mkShell {
      name = defaultPackageName;
      packages = [ (nixCatsBuilder defaultPackageName) ];
      inputsFrom = [ ];
      shellHook = ''
      '';
    };

    # To choose settings and categories from the flake that calls this flake.
    # and you export overlays so people dont have to redefine stuff.
    inherit customPackager;
  }) // {

    # these outputs will be NOT wrapped with ${system}

    # we also export a nixos module to allow configuration from configuration.nix
    nixosModules.default = utils.mkNixosModules {
      inherit defaultPackageName dependencyOverlays luaPath
        categoryDefinitions packageDefinitions nixpkgs;
    };
    # and the same for home manager
    homeModule = utils.mkHomeModules {
      inherit defaultPackageName dependencyOverlays luaPath
        categoryDefinitions packageDefinitions nixpkgs;
    };
    # now we can export some things that can be imported in other
    # flakes, WITHOUT needing to use a system variable to do it.
    # and update them into the rest of the outputs returned by the
    # eachDefaultSystem function.
    inherit utils categoryDefinitions packageDefinitions dependencyOverlays;
    inherit (utils) templates baseBuilder;
    keepLuaBuilder = utils.baseBuilder luaPath;
  };

}
