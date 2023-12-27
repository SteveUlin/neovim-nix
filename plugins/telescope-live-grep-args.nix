{
  config,
  helpers,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.plugins.telescope.extensions.live_grep_args;
in {
  options.plugins.telescope.extensions.live_grep_args = {
    enable = mkEnableOption "live_grep_args extension for telescope";

    package = helpers.mkPackageOption "telescope extension live_grep_args"
      pkgs.vimPlugins.telescope-live-grep-args-nvim;
  };

  config = mkIf cfg.enable {
    extraPlugins = [ cfg.package ];
    plugins.telescope.enabledExtensions = [ "live_grep_args" ];
  };
}
