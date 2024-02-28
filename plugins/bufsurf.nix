{
  config,
  helpers,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.plugins.bufsurf;
in {
  options.plugins.bufsurf = {
    enable = mkEnableOption "Bufsurf";

    package = helpers.mkPackageOption "Bufsurf"
      pkgs.vimPlugins.bufsurf;
  };

  config = mkIf cfg.enable {
    extraPlugins = [ cfg.package ];
  };
}
