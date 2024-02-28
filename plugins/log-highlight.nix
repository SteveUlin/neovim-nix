{
  config,
  helpers,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.plugins.log-highlight;
in {
  options.plugins.log-highlight = {
    enable = mkEnableOption "Log Highlight";

    package = helpers.mkPackageOption "Log Highlight"
      pkgs.vimPlugins.log-highlight;
  };

  config = mkIf cfg.enable {
    extraPlugins = [ cfg.package ];
  };
}
