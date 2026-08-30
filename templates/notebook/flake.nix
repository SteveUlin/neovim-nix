{
  description = "Quarto notebook with a store-resident Jupyter kernel";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};

      # Quarto pulls R and rmarkdown for its knitr engine — 1.8G of closure that
      # a python notebook never executes.
      quarto = pkgs.quarto.override {rWrapper = null;};

      python = pkgs.python3.withPackages (ps:
        with ps; [
          ipykernel
          numpy
          sympy
          matplotlib
          jax
          jaxlib
        ]);

      # jupyter_client scans $JUPYTER_PATH/kernels, so a kernelspec in the store
      # is a complete registration: nothing is written under ~/.local/share, and
      # the interpreter it names is a GC root of this shell.
      kernels = pkgs.linkFarm "jupyter-kernels" [
        {
          name = "kernels/notebook/kernel.json";
          path = pkgs.writeText "kernel.json" (builtins.toJSON {
            argv = ["${python}/bin/python" "-m" "ipykernel_launcher" "-f" "{connection_file}"];
            display_name = "notebook";
            language = "python";
          });
        }
      ];
    in {
      devShells.default = pkgs.mkShell {
        packages = [python quarto];
        JUPYTER_PATH = "${kernels}";
        # Molten writes each kernel's connection file to `data_dir/runtime`
        # without creating it, and ignores JUPYTER_RUNTIME_DIR.
        shellHook = ''
          export JUPYTER_DATA_DIR="''${XDG_RUNTIME_DIR:-/tmp}/jupyter"
          mkdir -p "$JUPYTER_DATA_DIR/runtime"
          # matplotlib otherwise resolves ./matplotlibrc against the kernel's
          # cwd, which is wherever nvim was launched.
          export MATPLOTLIBRC="$PWD/matplotlibrc"
        '';
      };
    });
}
