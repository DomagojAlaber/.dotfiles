{ pkgs, ... }:

let
  # Pre-made Yazi flavors (themes)
  yaziFlavors = pkgs.fetchFromGitHub {
    owner = "yazi-rs";
    repo = "flavors";
    rev = "f6b425a6d57af39c10ddfd94790759f4d7612332";
    # If this hash ever fails, run nix-prefetch and update it.
    hash = "sha256-bavHcmeGZ49nNeM+0DSdKvxZDPVm3e6eaNmfmwfCid0=";
  };
in
{
  programs.yazi = {
    enable = true;

    # Optional, but nice QoL
    shellWrapperName = "y"; # so you can just run `y`
    enableZshIntegration = true; # or fish/bash integrations if you prefer

    # Tools Yazi integrates with for search/preview/etc.
    extraPackages = with pkgs; [
      fd
      ripgrep
      fzf
      zoxide
      imagemagick
      ffmpegthumbnailer
    ];

    # yazi.toml
    settings = {
      manager = {
        # Panels: parent | current | preview
        ratio = [
          1
          3
          4
        ];

        sort_by = "natural";
        sort_sensitive = false;
        sort_reverse = false;
        sort_dir_first = true;

        linemode = "size"; # show file sizes on the right
        show_hidden = true;
        show_symlink = true;

        scrolloff = 5; # keep some context around cursor
        title_format = "yazi  {cwd}";
      };

      edit = "nvim";

      preview = {
        # Text preview
        wrap = "yes";
        tab_size = 2;

        # Image preview
        image_filter = "lanczos3";
        image_quality = 90;
        max_width = 600;
        max_height = 900;
        cache_dir = "";
        image_delay = 50;

        ueberzug_scale = 1;
        ueberzug_offset = [
          0
          0
          0
          0
        ];
      };

      tasks = {
        micro_workers = 5;
        macro_workers = 10;
        bizarre_retry = 5;
      };
    };

    # Pre-made flavor (Catppuccin Mocha)
    flavors = {
      # This will be symlinked to ~/.config/yazi/flavors/catppuccin-mocha.yazi
      catppuccin-mocha = "${yaziFlavors}/catppuccin-mocha.yazi";
    };

    # theme.toml
    theme = {
      # Use Catppuccin Mocha for both dark & light (so it’s always on)
      flavor = {
        dark = "catppuccin-mocha";
        light = "catppuccin-mocha";
      };

      # Extra ricing on top of the flavor
      mgr = {
        cwd = {
          fg = "#b4f9f8";
          bold = true;
        };
        hovered = {
          bg = "#363a4f";
        };
        preview_hovered = {
          bg = "#363a4f";
        };
        border_symbol = "│";
        border_style = {
          fg = "#6e738d";
        };
      };

      tabs = {
        active = {
          fg = "#1a1b26";
          bg = "#7dcfff";
          bold = true;
        };
        inactive = {
          fg = "#c0caf5";
          bg = "#24283b";
        };
        sep_inner = {
          open = "";
          close = "";
        };
        sep_outer = {
          open = " ";
          close = " ";
        };
      };

      status = {
        overall = {
          fg = "#c0caf5";
          bg = "#1a1b26";
        };
        progress_label = {
          fg = "#1a1b26";
          bg = "#7dcfff";
          bold = true;
        };
        progress_normal = {
          fg = "#1a1b26";
          bg = "#9ece6a";
        };
        progress_error = {
          fg = "#1a1b26";
          bg = "#f7768e";
        };
      };

      # Extra icons on top of builtin devicons
      icon = {
        prepend_dirs = [
          {
            name = "Downloads";
            text = "";
            fg = "#f7768e";
          }
          {
            name = "Documents";
            text = "";
            fg = "#9ece6a";
          }
          {
            name = "Pictures";
            text = "";
            fg = "#bb9af7";
          }
          {
            name = "Videos";
            text = "";
            fg = "#e0af68";
          }
        ];
      };

      # Give media / code types some color
      filetype = {
        rules = [
          {
            mime = "image/*";
            fg = "#f5a97f";
          }
          {
            mime = "video/*";
            fg = "#e0af68";
          }
          {
            mime = "audio/*";
            fg = "#9ece6a";
          }
          {
            mime = "text/x-python";
            fg = "#9ece6a";
          }
          {
            mime = "text/x-go";
            fg = "#7aa2f7";
          }
          {
            mime = "text/x-c";
            fg = "#bb9af7";
          }
          {
            mime = "application/zip";
            fg = "#f7768e";
          }
          {
            name = "*/";
            fg = "#7dcfff";
          } # directories fallback
        ];
      };
    };
  };
}
