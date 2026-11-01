{
  lib,
  ...
}:

let
  cursorThemeName = "catppuccin-mocha-dark-cursors";
  cursorSize = 24;

  lua = lib.generators.mkLuaInline;
  mkLuaBind = keys: dispatcher: {
    _args = [
      keys
      (lua dispatcher)
    ];
  };
  modKey = key: lua ''mainMod .. " + ${key}"'';
  mkBezier = name: points: {
    _args = [
      name
      {
        type = "bezier";
        inherit points;
      }
    ];
  };

in
{
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";
    xwayland.enable = true;

    settings = {
      ################
      ### MONITORS ###
      ################
      monitor = [
        {
          output = "eDP-1";
          mode = "highres@highr";
          position = "auto";
          scale = 1;
        }
        {
          output = "DP-1";
          mode = "highres@highr";
          position = "0x0";
          scale = 1;
        }
        {
          output = "DP-2";
          mode = "highres@highr";
          position = "auto";
          scale = 1;
        }
        {
          output = "DP-3";
          mode = "highres@highr";
          position = "auto";
          scale = 1;
        }
      ];

      ###################
      ### MY PROGRAMS ###
      ###################
      terminal._var = "kitty";
      fileManager._var = "yazi";
      menu._var = "rofi -show drun -show-icons";
      mainMod._var = "SUPER";

      #############################
      ### ENVIRONMENT VARIABLES ###
      #############################
      env = [
        {
          _args = [
            "XCURSOR_THEME"
            cursorThemeName
          ];
        }
        {
          _args = [
            "XCURSOR_SIZE"
            (toString cursorSize)
          ];
        }
        {
          _args = [
            "HYPRCURSOR_SIZE"
            (toString cursorSize)
          ];
        }
      ];

      #####################
      ### LOOK AND FEEL ###
      #####################
      config = {
        general = {
          gaps_in = 1;
          gaps_out = 0;
          border_size = 1;

          snap = {
            enabled = true;
            window_gap = 4;
            monitor_gap = 5;
            respect_gaps = false;
            border_overlap = false;
          };

          col = {
            active_border = "rgba(9932ccff)";
            inactive_border = "rgba(cba6f7cc)";
          };

          resize_on_border = false;
          allow_tearing = false;
          layout = "dwindle";
        };

        decoration = {
          rounding = 2;
          active_opacity = 0.95;
          inactive_opacity = 0.90;
        };

        animations.enabled = true;

        dwindle.preserve_split = true;

        master.new_status = "master";

        misc = {
          force_default_wallpaper = -1;
          disable_hyprland_logo = false;
        };

        input = {
          kb_layout = "us,hr";
          kb_variant = "";
          kb_model = "";
          kb_options = "grp:alt_shift_toggle";
          kb_rules = "";

          follow_mouse = 1;
          sensitivity = 0;
          accel_profile = "flat";

          touchpad.natural_scroll = false;
        };
      };

      curve = [
        (mkBezier "easeOutQuint" [
          [
            0.23
            1
          ]
          [
            0.32
            1
          ]
        ])
        (mkBezier "easeInOutCubic" [
          [
            0.65
            0.05
          ]
          [
            0.36
            1
          ]
        ])
        (mkBezier "linear" [
          [
            0
            0
          ]
          [
            1
            1
          ]
        ])
        (mkBezier "almostLinear" [
          [
            0.5
            0.5
          ]
          [
            0.75
            1
          ]
        ])
        (mkBezier "quick" [
          [
            0.15
            0
          ]
          [
            0.1
            1
          ]
        ])
      ];

      animation = [
        {
          leaf = "global";
          enabled = true;
          speed = 6;
          bezier = "default";
        }
        {
          leaf = "border";
          enabled = true;
          speed = 3.5;
          bezier = "easeOutQuint";
        }
        {
          leaf = "windows";
          enabled = true;
          speed = 3;
          bezier = "easeOutQuint";
        }
        {
          leaf = "windowsIn";
          enabled = true;
          speed = 2.6;
          bezier = "easeOutQuint";
          style = "popin 87%";
        }
        {
          leaf = "windowsOut";
          enabled = true;
          speed = 1;
          bezier = "linear";
          style = "popin 87%";
        }
        {
          leaf = "fadeIn";
          enabled = true;
          speed = 1.2;
          bezier = "almostLinear";
        }
        {
          leaf = "fadeOut";
          enabled = true;
          speed = 1;
          bezier = "almostLinear";
        }
        {
          leaf = "fade";
          enabled = true;
          speed = 2;
          bezier = "quick";
        }
        {
          leaf = "layers";
          enabled = true;
          speed = 2.5;
          bezier = "easeOutQuint";
        }
        {
          leaf = "layersIn";
          enabled = true;
          speed = 2.6;
          bezier = "easeOutQuint";
          style = "fade";
        }
        {
          leaf = "layersOut";
          enabled = true;
          speed = 1;
          bezier = "linear";
          style = "fade";
        }
        {
          leaf = "fadeLayersIn";
          enabled = true;
          speed = 1.2;
          bezier = "almostLinear";
        }
        {
          leaf = "fadeLayersOut";
          enabled = true;
          speed = 1;
          bezier = "almostLinear";
        }
        {
          leaf = "workspaces";
          enabled = true;
          speed = 1.3;
          bezier = "almostLinear";
          style = "fade";
        }
        {
          leaf = "workspacesIn";
          enabled = true;
          speed = 1;
          bezier = "almostLinear";
          style = "fade";
        }
        {
          leaf = "workspacesOut";
          enabled = true;
          speed = 1.3;
          bezier = "almostLinear";
          style = "fade";
        }
      ];

      ###################
      ### KEYBINDINGS ###
      ###################
      bind = [
        (mkLuaBind (modKey "return") "hl.dsp.exec_cmd(terminal)")
        (mkLuaBind (modKey "C") "hl.dsp.window.close()")
        (mkLuaBind (modKey "M") "hl.dsp.exit()")
        (mkLuaBind (modKey "E") "hl.dsp.exec_cmd(fileManager)")
        (mkLuaBind (modKey "V") ''hl.dsp.window.float({ action = "toggle" })'')
        (mkLuaBind (modKey "P") ''hl.dsp.window.pseudo({ action = "toggle" })'')
        (mkLuaBind (modKey "S") "hl.dsp.exec_cmd(menu)")
        (mkLuaBind (modKey "O") ''hl.dsp.exec_cmd("cliphist list | rofi -dmenu | cliphist decode | wl-copy")'')
        (mkLuaBind (modKey "W") ''hl.dsp.exec_cmd("wallpaper-switcher")'')
        (mkLuaBind (modKey "F") ''hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" })'')
        (mkLuaBind (modKey "PRINT") ''hl.dsp.exec_cmd("hyprshot -m region --clipboard-only")'')

        (mkLuaBind (modKey "1") "hl.dsp.focus({ workspace = 1 })")
        (mkLuaBind (modKey "2") "hl.dsp.focus({ workspace = 2 })")
        (mkLuaBind (modKey "3") "hl.dsp.focus({ workspace = 3 })")
        (mkLuaBind (modKey "4") "hl.dsp.focus({ workspace = 4 })")
        (mkLuaBind (modKey "5") "hl.dsp.focus({ workspace = 5 })")
        (mkLuaBind (modKey "6") "hl.dsp.focus({ workspace = 6 })")
        (mkLuaBind (modKey "7") "hl.dsp.focus({ workspace = 7 })")
        (mkLuaBind (modKey "8") "hl.dsp.focus({ workspace = 8 })")
        (mkLuaBind (modKey "9") "hl.dsp.focus({ workspace = 9 })")
        (mkLuaBind (modKey "0") "hl.dsp.focus({ workspace = 10 })")

        (mkLuaBind (modKey "SHIFT + 1") "hl.dsp.window.move({ workspace = 1, follow = true })")
        (mkLuaBind (modKey "SHIFT + 2") "hl.dsp.window.move({ workspace = 2, follow = true })")
        (mkLuaBind (modKey "SHIFT + 3") "hl.dsp.window.move({ workspace = 3, follow = true })")
        (mkLuaBind (modKey "SHIFT + 4") "hl.dsp.window.move({ workspace = 4, follow = true })")
        (mkLuaBind (modKey "SHIFT + 5") "hl.dsp.window.move({ workspace = 5, follow = true })")
        (mkLuaBind (modKey "SHIFT + 6") "hl.dsp.window.move({ workspace = 6, follow = true })")
        (mkLuaBind (modKey "SHIFT + 7") "hl.dsp.window.move({ workspace = 7, follow = true })")
        (mkLuaBind (modKey "SHIFT + 8") "hl.dsp.window.move({ workspace = 8, follow = true })")
        (mkLuaBind (modKey "SHIFT + 9") "hl.dsp.window.move({ workspace = 9, follow = true })")
        (mkLuaBind (modKey "SHIFT + 0") "hl.dsp.window.move({ workspace = 10, follow = true })")

        (mkLuaBind (modKey "left") ''hl.dsp.focus({ direction = "l" })'')
        (mkLuaBind (modKey "right") ''hl.dsp.focus({ direction = "r" })'')
        (mkLuaBind (modKey "up") ''hl.dsp.focus({ direction = "u" })'')
        (mkLuaBind (modKey "down") ''hl.dsp.focus({ direction = "d" })'')

        (mkLuaBind (modKey "h") ''hl.dsp.focus({ direction = "l" })'')
        (mkLuaBind (modKey "l") ''hl.dsp.focus({ direction = "r" })'')
        (mkLuaBind (modKey "k") ''hl.dsp.focus({ direction = "u" })'')
        (mkLuaBind (modKey "j") ''hl.dsp.focus({ direction = "d" })'')

        (mkLuaBind (modKey "SHIFT + h") ''hl.dsp.window.move({ direction = "l" })'')
        (mkLuaBind (modKey "SHIFT + l") ''hl.dsp.window.move({ direction = "r" })'')
        (mkLuaBind (modKey "SHIFT + k") ''hl.dsp.window.move({ direction = "u" })'')
        (mkLuaBind (modKey "SHIFT + j") ''hl.dsp.window.move({ direction = "d" })'')
      ];
    };
  };

}
