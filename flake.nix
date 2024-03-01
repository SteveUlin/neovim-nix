{
  description = "sulin's Neovim Flake";

  inputs = {
    # https://github.com/nix-community/nixvim/pull/1168
    # nixpkgs.url = "github:NixOS/nixpkgs/d8e0944e6d2ce0f326040e654c07a410e2617d47";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    neovim = {
      url = "github:neovim/neovim?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";

    neorg-overlay.url = "github:nvim-neorg/nixpkgs-neorg-overlay";

    neorg-exec-src = {
      url = "github:laher/neorg-exec";
      flake = false;
    };
    bufsurf-src = {
      url = "github:ton/vim-bufsurf";
      flake = false;
    };
    log-highlight = {
      url = "github:fei6409/log-highlight.nvim";
      flake = false;
    };
    everforest = {
      url = "github:neanias/everforest-nvim";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    neovim,
    nixvim,
    flake-utils,
    neorg-overlay,
    ...
  }@inputs:
    flake-utils.lib.eachDefaultSystem (system: let
    pkgs = import nixpkgs {
      inherit system;
      overlays = [
        neorg-overlay.overlays.default
        (final: prev: {
          vimPlugins = prev.vimPlugins //
          {
            neorg-exec = final.vimUtils.buildVimPlugin {
              name = "neorg-exec";
              src = inputs.neorg-exec-src;
            };
            bufsurf = final.vimUtils.buildVimPlugin {
              name = "bufsurf";
              src = inputs.bufsurf-src;
            };
            log-highlight = final.vimUtils.buildVimPlugin {
              name = "log-highlight";
              src = inputs.log-highlight;
            };
            everforest = final.vimUtils.buildVimPlugin {
              name = "everforest";
              src = inputs.everforest;
            };
          };
        })
      ];
    };

    nixvim' = nixvim.legacyPackages."${system}";
    nvim = nixvim'.makeNixvimWithModule {
      inherit pkgs;
      module = {
        imports = [ ./plugins ./config ];
        package = neovim.packages."${system}".neovim;
        extraPackages = with pkgs; [
          delta
          julia
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
