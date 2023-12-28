{
  config,
  helpers,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.plugins.venn-nvim;
in {
  options.plugins.venn-nvim = {
    enable = mkEnableOption "Venn Nvim";

    package = helpers.mkPackageOption "Venn Nvim"
      pkgs.vimPlugins.venn-nvim;
  };

  config = mkIf cfg.enable {
    extraPlugins = [ cfg.package ];
  };
}
