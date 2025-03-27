{
  description = "sulin's Neovim Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neorg-overlay = {
      url = "github:nvim-neorg/nixpkgs-neorg-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";

    bufsurf-src = {
      url = "github:ton/vim-bufsurf";
      flake = false;
    };
    
    log-highlight = {
      url = "github:fei6409/log-highlight.nvim";
      flake = false;
    };
    
    everforest-src = {
      url = "github:neanias/everforest-nvim";
      flake = false;
    };

    eyeliner-src = {
      url = "github:jinh0/eyeliner.nvim";
      flake = false;
    };

    markview-src = {
      url = "github:OXY2DEV/markview.nvim";
      flake = false;
    };

    mdx = {
      url = "github:davidmh/mdx.nvim";
      flake = false;
    };

    tiny-inline-diagnostic-src = {
      url = "github:rachartier/tiny-inline-diagnostic.nvim";
      flake = false;
    };

    diagflow-src = {
      url = "github:dgagn/diagflow.nvim";
      flake = false;
    };

    snacks-src = {
      url = "github:folke/snacks.nvim";
      flake = false;
    };

    copilot-lua-src = {
      url = "github:zbirenbaum/copilot.lua";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    neovim-nightly-overlay,
    nixvim,
    flake-utils,
    neorg-overlay,
    ...
  }@inputs:
    flake-utils.lib.eachDefaultSystem (system: let
    pkgs = import nixpkgs {
      config.allowUnfree = true;
      inherit system;
      overlays = [
        neovim-nightly-overlay.overlays.default
        neorg-overlay.overlays.default
        (final: prev: {
          vimPlugins = prev.vimPlugins //
          {
            mdx = final.vimUtils.buildVimPlugin {
              name = "mdx";
              src = inputs.mdx;
            };
            bufsurf = final.vimUtils.buildVimPlugin {
              name = "bufsurf";
              src = inputs.bufsurf-src;
            };
            eyeliner = final.vimUtils.buildVimPlugin {
              name = "eyeliner";
              src = inputs.eyeliner-src;
            };
            log-highlight = final.vimUtils.buildVimPlugin {
              name = "log-highlight";
              src = inputs.log-highlight;
            };
            everforest-nvim = final.vimUtils.buildVimPlugin {
              name = "everforest-nvim";
              src = inputs.everforest-src;
            };
            markview-nvim = final.vimUtils.buildVimPlugin {
              name = "markview-nvim";
              src = inputs.markview-src;
            };
            tiny-inline-diagnostic = final.vimUtils.buildVimPlugin {
              name = "tiny-inline-diagnostic";
              src = inputs.tiny-inline-diagnostic-src;
            };
            diagflow = final.vimUtils.buildVimPlugin {
              name = "diagflow";
              src = inputs.diagflow-src;
            };
            snacks-head = final.vimUtils.buildVimPlugin {
              name = "snacks-head";
              src = inputs.snacks-src;
              doCheck = false;
            };
            copilot-lua = final.vimUtils.buildVimPlugin {
              name = "copilot-lua";
              src = inputs.copilot-lua-src;
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
            clang_20
            delta
            rustfmt
            lynx
            lua51Packages.tiktoken_core
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

