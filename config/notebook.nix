{
  pkgs,
  lib,
  ...
}: let
  nbKeymap = mode: key: action: desc: {
    inherit mode key action;
    options = {
      silent = true;
      noremap = true;
      inherit desc;
    };
  };
  nmap = nbKeymap "n";
in {
  # The quarto CLI is a ~1G closure and only `:QuartoPreview` needs it; it
  # belongs to the project shell that renders, not to every editor install.
  extraPackages = [
    # snacks.image shells out to `magick` for every format but raw PNG.
    pkgs.imagemagick
    # $..$ compiles to a standalone PDF, which magick rasterises through gs.
    pkgs.tectonic
    pkgs.ghostscript
  ];

  plugins = {
    otter = {
      enable = true;
      # quarto.activate() passes the configured languages and its own tsquery;
      # the lsp-attach hook activates with defaults and fights it.
      autoActivate = false;
    };

    quarto = {
      enable = true;
      settings = {
        lspFeatures = {
          enabled = true;
          languages = ["python" "bash" "html"];
          completion.enabled = true;
          diagnostics = {
            enabled = true;
            triggers = ["BufWritePost"];
          };
        };
        codeRunner = {
          enabled = true;
          default_method = "molten";
        };
      };
    };

    molten = {
      enable = true;
      settings = {
        # Output renders as extmarks in the buffer — images included — so a cell
        # run never moves focus or opens a window.
        virt_text_output = true;
        auto_open_output = false;
        # Markdown fences close on their own line; without this the output
        # anchors one line high and covers the closing fence.
        virt_lines_off_by_1 = true;
        wrap_output = true;
        virt_text_max_lines = 30;
        output_win_max_height = 30;
        image_provider = "snacks.nvim";
      };
    };

    # Round-trips .ipynb through quarto markdown, so foreign notebooks open as
    # the same buffer shape as a hand-written .qmd.
    jupytext = {
      enable = true;
      settings.custom_language_formatting.python = {
        extension = "qmd";
        style = "quarto";
        force_ft = "quarto";
      };
    };

    # Screenshots and hand-drawn diagrams reach a notebook by clipboard, not by
    # a cell; img-clip writes the file and inserts the markdown reference.
    img-clip = {
      enable = true;
      settings = {
        default = {
          dir_path = "assets";
          relative_to_current_file = true;
          prompt_for_file_name = false;
        };
        filetypes.quarto.download_images = true;
      };
    };

    snacks-nvim.settings.image = {
      enabled = true;
      doc = {
        # Typesets $..$ and $$..$$ and draws linked images inline; markview
        # keeps the rest of the markdown chrome.
        enabled = true;
        # molten sizes its placements from these.
        max_width = 100;
        max_height = 40;
      };
    };
  };

  # Ordered after the plugins' own setup() calls.
  extraConfigLua = lib.mkOrder 1200 ''
    -- No grammar is named `quarto`; markdown parses the document and otter
    -- queries that tree to find the embedded chunks.
    vim.treesitter.language.register("markdown", "quarto")

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "quarto",
      callback = function(ev)
        require("quarto").activate()

        -- molten only tracks cells it has run, so its next/prev skip fences
        -- that have never been evaluated; match the fence itself instead.
        local function fence(flags)
          return function()
            vim.fn.search("^```{", flags)
          end
        end
        vim.keymap.set("n", "]m", fence("W"), { buffer = ev.buf, desc = "⬇️  Next Cell" })
        vim.keymap.set("n", "[m", fence("bW"), { buffer = ev.buf, desc = "⬆️  Previous Cell" })
      end,
    })

    -- Zellij carries the kitty graphics protocol from 0.45 on, which snacks
    -- still flags unsupported. Placeholders stay off — only the protocol
    -- landed. Emitting it to an older zellij would spray escapes at the pane.
    if vim.env.ZELLIJ then
      local out = vim.system({ "zellij", "--version" }, { text = true }):wait()
      local major, minor = (out.stdout or ""):match("(%d+)%.(%d+)")
      if major and (tonumber(major) * 1000 + tonumber(minor)) >= 45 then
        for _, term in ipairs(require("snacks.image.terminal").envs()) do
          if term.name == "zellij" then
            term.supported = true
          end
        end
      end
    end
  '';

  keymaps = [
    (nmap "<leader>ji" "<cmd>MoltenInit<CR>" "🔌 Attach Kernel")
    (nmap "<leader>jI" "<cmd>MoltenDeinit<CR>" "🔌 Detach Kernel")
    (nmap "<leader>jr" "<cmd>QuartoSend<CR>" "▶️  Run Cell")
    (nmap "<leader>jl" "<cmd>QuartoSendLine<CR>" "▶️  Run Line")
    (nmap "<leader>ja" "<cmd>QuartoSendAll<CR>" "▶️  Run All")
    (nmap "<leader>jb" "<cmd>QuartoSendBelow<CR>" "▶️  Run Cell + Below")
    (nmap "<leader>jA" "<cmd>QuartoSendAbove<CR>" "▶️  Run Above")
    (nbKeymap "v" "<leader>jr" ":<C-u>QuartoSendRange<CR>" "▶️  Run Selection")
    (nmap "<leader>jo" "<cmd>noautocmd MoltenEnterOutput<CR>" "📤 Enter Output")
    (nmap "<leader>jh" "<cmd>MoltenHideOutput<CR>" "🙈 Hide Output")
    (nmap "<leader>jv" "<cmd>MoltenToggleVirtual<CR>" "👁️  Toggle Virtual Output")
    (nmap "<leader>jx" "<cmd>MoltenInterrupt<CR>" "🛑 Interrupt Kernel")
    (nmap "<leader>jX" "<cmd>MoltenRestart!<CR>" "♻️  Restart Kernel")
    (nmap "<leader>jd" "<cmd>MoltenDelete<CR>" "🗑️  Delete Cell")
    (nmap "<leader>jn" "<cmd>MoltenNext<CR>" "⬇️  Next Evaluated Cell")
    (nmap "<leader>jp" "<cmd>MoltenPrev<CR>" "⬆️  Previous Evaluated Cell")
    (nmap "<leader>jP" "<cmd>QuartoPreview<CR>" "🌐 Preview Document")
    # Markup-wide, not notebook-specific: lives with the Notes prefix.
    (nmap "<leader>ni" "<cmd>PasteImage<CR>" "🖼️  Paste Image from Clipboard")
  ];
}
