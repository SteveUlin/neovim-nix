{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.colorschemes.everforest;
in {
  options = {
    colorschemes.everforest = {
      enable = mkEnableOption "everforest";

      package = helpers.mkPackageOption "everforest" pkgs.vimPlugins.everforest;
    };
  };

  config = let
    setupOptions = {
      background = "hard";
      italics = true;
      sign_column_background = "grey";
    };
  in mkIf cfg.enable {
    colorscheme = "everforest";
    options = {
      termguicolors = mkDefault true;
    };
    extraPlugins = [cfg.package];
    extraConfigLuaPre = ''
      require("everforest").setup(${helpers.toLuaObject setupOptions});
    '';
  };
}
