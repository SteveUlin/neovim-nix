{
  lib,
  ...
}:
lib.nixvim.plugins.neovim.mkNeovimPlugin {
  name = "everforest-nvim";
  isColorscheme = true;
  package = "everforest-nvim";
  moduleName = "everforest";
  colorscheme = "everforest";
  maintainers = [];

  settingsOptions = {
    italics = lib.nixvim.defaultNullOpts.mkBool true
      "Italicize certain syntax groups";
    on_highlights = lib.nixvim.defaultNullOpts.mkLuaFn
      "function(highlights, colors) end" ''
      Override specific highlights to use other groups or a hex color.
      Function will be called with a `Highlights` and `ColorScheme` table.
      `@param highlights Highlights`
      `@param colors ColorScheme`
    '';
  };
  
  extraConfig = cfg: { opts.termguicolors = lib.mkDefault true; };
}
