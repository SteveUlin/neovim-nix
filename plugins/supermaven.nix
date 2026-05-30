{
  lib,
  config,
  pkgs,
  ...
}: {
  # Opt-in AI autocomplete. Off by default so the data path to Supermaven's
  # servers only exists on builds that explicitly set `aiCompletion.enable`
  # (the `nvim-ai` package). The accompanying list in `plugins.nix` adds the
  # "supermaven" blink source under the same flag, since blink's `sources.default`
  # list cannot be merged across modules.
  options.aiCompletion.enable = lib.mkEnableOption ''
    Supermaven AI completion. Sends surrounding buffer context to Supermaven's
    servers — keep this OFF on machines with confidential code (e.g. work)
  '';

  config = lib.mkIf config.aiCompletion.enable {
    # The blink source plugin (overlaid into pkgs.vimPlugins in flake.nix).
    extraPlugins = [pkgs.vimPlugins.blink-cmp-supermaven];

    plugins.supermaven = {
      enable = true;
      settings = {
        # Hand suggestions to blink.cmp instead of drawing our own ghost text,
        # and let blink own the keymaps (Tab/<C-j>/<C-k>) so there's no clash.
        disable_inline_completion = true;
        disable_keymaps = true;
      };
    };

    # Register the blink provider. `providers` is an attrset keyed by name, so
    # this merges cleanly with the latex_symbols provider defined in plugins.nix.
    plugins.blink-cmp.settings.sources.providers.supermaven = {
      name = "supermaven";
      module = "blink-cmp-supermaven";
      async = true;
    };
  };
}
