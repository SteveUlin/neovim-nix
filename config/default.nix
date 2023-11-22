{ pkgs }:
let
  lua-file-names = builtins.attrNames (builtins.readDir ./lua);
  # Gross, but necessary
  lua-paths = map (name: ./lua + "/${name}") lua-file-names;
in
builtins.concatStringsSep "\n"
  (builtins.map (path: "luafile ${path}") lua-paths)

