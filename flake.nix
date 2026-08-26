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

    async-src = {
      url = "github:lewis6991/async.nvim";
      flake = false;
    };

    claudecode-src = {
      url = "github:coder/claudecode.nvim";
      flake = false;
    };

    # Blink source that surfaces Supermaven completions inside the blink.cmp
    # menu. Optional: only wired into the `nvim-ai` package (see outputs), kept
    # out of the default build so work machines never ship Supermaven.
    blink-cmp-supermaven-src = {
      url = "github:Huijiro/blink-cmp-supermaven";
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
            async-nvim = final.vimUtils.buildVimPlugin {
              name = "async-nvim";
              src = inputs.async-src;
              doCheck = false;
            };
            claudecode-nvim = final.vimUtils.buildVimPlugin {
              name = "claudecode-nvim";
              src = inputs.claudecode-src;
              doCheck = false;
            };
            blink-cmp-supermaven = final.vimUtils.buildVimPlugin {
              name = "blink-cmp-supermaven";
              src = inputs.blink-cmp-supermaven-src;
              doCheck = false;
            };
          };
        })
      ];
    };

    nixvim' = nixvim.legacyPackages.${system};

    # Shared configuration. The `./plugins/supermaven.nix` module is always
    # imported but inert unless `aiCompletion.enable` is set, so the default
    # build carries no Supermaven code at all.
    baseModule = {
      imports = [ ./plugins ./config ];
      extraPackages = with pkgs; [
          clang-tools
          delta
          rustfmt
          zig
          zls
          lynx
          lua51Packages.tiktoken_core
          sqlite  # Required for sqlite.lua and snacks.nvim frecency
          # Formatters for conform-nvim
          stylua
          black
          alejandra
          prettier
          # Linters for nvim-lint
          ruff
          markdownlint-cli
      ];
    };

    # Work-safe default: no Supermaven, nothing leaves the machine.
    nvim = nixvim'.makeNixvimWithModule {
      inherit pkgs;
      module = baseModule;
    };

    # Personal build: same config plus Supermaven wired into blink.cmp.
    # Build/reference this one (`.#nvim-ai`) only on machines where sending
    # buffer context to Supermaven's servers is acceptable.
    nvim-ai = nixvim'.makeNixvimWithModule {
      inherit pkgs;
      module = {
        imports = [ baseModule ];
        aiCompletion.enable = true;
      };
    };
    # The nixpkgs wrapper generates its remote-plugin manifest before the python3
    # host is wired up, so molten's commands are missing from it. Regenerating
    # against the finished editor pins a manifest naming the same plugin paths;
    # supermaven is not a remote plugin, so both builds share this one.
    rpluginManifest = pkgs.runCommand "nvim-rplugin-manifest" {} ''
      export HOME="$(mktemp -d)"
      export NVIM_RPLUGIN_MANIFEST="$out"
      ${nvim}/bin/nvim --headless -i NONE -n +UpdateRemotePlugins +qa!
    '';

    withRemotePlugins = name: pkg:
      pkgs.symlinkJoin {
        inherit name;
        paths = [ pkg ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/nvim \
            --set NVIM_RPLUGIN_MANIFEST ${rpluginManifest}
        '';
      };
    wrappedNvim = withRemotePlugins "nixvim" nvim;
    wrappedNvimAi = withRemotePlugins "nixvim-ai" nvim-ai;
    in {
      packages = {
        nvim = wrappedNvim;
        nvim-ai = wrappedNvimAi;
        default = wrappedNvim;
      };
    })
    // {
      templates.notebook = {
        path = ./templates/notebook;
        description = "Quarto notebook with a store-resident Jupyter kernel";
      };
    };
}

