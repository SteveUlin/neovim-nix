{
  config,
  helpers,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.plugins.neorg-exec;
in {
  options.plugins.neorg-exec = {
    enable = mkEnableOption "neorg-exec extension for neorg";

    package = helpers.mkPackageOption "neorg-exec extension for neorg"
      pkgs.vimPlugins.neorg-exec;
  };

  config = mkIf cfg.enable {
    extraPlugins = [ cfg.package ];
    plugins.neorg.modules = {
      "external.exec" = { __empty = null; };
    };
  };
}
