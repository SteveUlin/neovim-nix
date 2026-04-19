{
  description = "sulin's Neovim Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";

    bufsurf-src = {
      url = "github:ton/vim-bufsurf";
      flake = false;
    };
    
    everforest-src = {
      url = "github:neanias/everforest-nvim";
      flake = false;
    };

    tiny-inline-diagnostic-src = {
      url = "github:rachartier/tiny-inline-diagnostic.nvim";
      flake = false;
    };

    snacks-src = {
      url = "github:folke/snacks.nvim";
      flake = false;
    };

    vcsigns-src = {
      url = "github:algmyr/vcsigns.nvim";
      flake = false;
    };

    vclib-src = {
      url = "github:algmyr/vclib.nvim";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    neovim-nightly-overlay,
    nixvim,
    flake-utils,
    ...
  }@inputs:
    flake-utils.lib.eachDefaultSystem (system: let
    pkgs = import nixpkgs {
      config.allowUnfree = true;
      inherit system;
      overlays = [
        neovim-nightly-overlay.overlays.default
        (final: prev: {
          vimPlugins = prev.vimPlugins //
          {
            bufsurf = final.vimUtils.buildVimPlugin {
              name = "bufsurf";
              src = inputs.bufsurf-src;
            };
            everforest-nvim = final.vimUtils.buildVimPlugin {
              name = "everforest-nvim";
              src = inputs.everforest-src;
            };
            tiny-inline-diagnostic = final.vimUtils.buildVimPlugin {
              name = "tiny-inline-diagnostic";
              src = inputs.tiny-inline-diagnostic-src;
            };
            snacks-head = final.vimUtils.buildVimPlugin {
              name = "snacks-head";
              src = inputs.snacks-src;
              doCheck = false;
            };
            vcsigns = final.vimUtils.buildVimPlugin {
              name = "vcsigns";
              src = inputs.vcsigns-src;
              doCheck = false;
            };
            vclib = final.vimUtils.buildVimPlugin {
              name = "vclib";
              src = inputs.vclib-src;
              doCheck = false;
            };
          };
        })
      ];
    };

    nixvim' = nixvim.legacyPackages.${system};
    nvim = nixvim'.makeNixvimWithModule {
      inherit pkgs;
      module = {
        imports = [ ./plugins ./config ];
        extraPackages = with pkgs; [
            clang-tools
            delta
            rustfmt
            lynx
            lua51Packages.tiktoken_core
            sqlite  # Required for sqlite.lua and snacks.nvim frecency
            # Formatters for conform-nvim
            stylua
            black
            alejandra
            prettier
            # Linters for nvim-lint
            pylint
            markdownlint-cli
        ];
      };
    };
    in {
      packages = {
        inherit nvim;
        default = nvim;
      };
    });
}

