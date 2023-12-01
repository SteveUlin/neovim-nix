{ pkgs }:
let
  customRC = import ../config { inherit pkgs; };
  plugins = import ../plugins.nix { inherit pkgs; };
  runtimeDeps = import ../runtimeDeps.nix {inherit pkgs; };

  myNeovim = pkgs.wrapNeovimUnstable pkgs.neovim (pkgs.neovimUtils.makeNeovimConfig {
    extraLuaPackages = p: with p; [ magick ];
    inherit plugins;
    inherit customRC;
  });
in pkgs.symlinkJoin {
  name = "neovim";
  paths = [ myNeovim ] ++ runtimeDeps;
  buildInputs = [ pkgs.makeWrapper ];
  postBuild = "wrapProgram $out/bin/nvim --prefix PATH : $out/bin";
}
