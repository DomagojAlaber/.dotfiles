{
  lib,
  pkgs,
  ...
}:

let
  cursorThemeName = "catppuccin-mocha-dark-cursors";
  cursorSize = 24;
  hyprlandTarget = "hyprland-session.target";
  cliphistMaxItems = "9223372036854775807";

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

  wallpaperSwitcher = pkgs.writeShellApplication {
    name = "wallpaper-switcher";
    runtimeInputs = with pkgs; [
      awww
      coreutils
      findutils
      libnotify
      rofi
    ];
    text = ''
      WALLPAPER_DIR="''${WALLPAPER_DIR:-$HOME/.dotfiles/Wallpapers}"
      STATE_DIR="''${XDG_STATE_HOME:-$HOME/.local/state}/wallpaper-switcher"
      STATE_FILE="$STATE_DIR/current"
      DEFAULT_WALLPAPER="$WALLPAPER_DIR/knight-templar.jpg"

      notify() {
        if command -v notify-send >/dev/null 2>&1; then
          notify-send "$@"
        fi
      }

      die() {
        notify "Wallpaper switcher" "$1"
        printf 'wallpaper-switcher: %s\n' "$1" >&2
        exit 1
      }

      usage() {
        cat <<'EOF'
      Usage:
        wallpaper-switcher           Pick and apply a wallpaper with rofi
        wallpaper-switcher --restore Restore the last selected wallpaper

      Environment:
        WALLPAPER_DIR                Directory to scan for images
      EOF
      }

      ensure_wallpaper_dir() {
        [[ -d "$WALLPAPER_DIR" ]] || die "Wallpaper directory not found: $WALLPAPER_DIR"
      }

      list_wallpapers() {
        find "$WALLPAPER_DIR" -type f \( \
          -iname '*.jpg' -o \
          -iname '*.jpeg' -o \
          -iname '*.png' -o \
          -iname '*.webp' -o \
          -iname '*.gif' -o \
          -iname '*.bmp' \
        \) -print0 | sort -z
      }

      load_wallpapers() {
        ensure_wallpaper_dir
        mapfile -d "" WALLPAPERS < <(list_wallpapers)
        ((''${#WALLPAPERS[@]} > 0)) || die "No supported images found in $WALLPAPER_DIR"
      }

      ensure_daemon() {
        if ! awww query >/dev/null 2>&1; then
          awww-daemon >/dev/null 2>&1 &
          sleep 0.5
        fi
      }

      apply_wallpaper() {
        local wallpaper="$1"

        [[ -f "$wallpaper" ]] || die "Wallpaper not found: $wallpaper"

        ensure_daemon
        awww img --transition-type random --transition-duration 1 "$wallpaper"
      }

      record_wallpaper() {
        mkdir -p "$STATE_DIR"
        printf '%s\n' "$1" >"$STATE_FILE"
      }

      restore_wallpaper() {
        local wallpaper=""

        if [[ -r "$STATE_FILE" ]]; then
          IFS= read -r wallpaper <"$STATE_FILE" || true
        fi

        if [[ -z "$wallpaper" || ! -f "$wallpaper" ]]; then
          if [[ -f "$DEFAULT_WALLPAPER" ]]; then
            wallpaper="$DEFAULT_WALLPAPER"
          else
            load_wallpapers
            wallpaper="''${WALLPAPERS[0]}"
          fi
        fi

        apply_wallpaper "$wallpaper"
      }

      show_menu() {
        load_wallpapers

        local entries=()
        local wallpaper rel choice selected=""

        for wallpaper in "''${WALLPAPERS[@]}"; do
          rel="''${wallpaper#"$WALLPAPER_DIR"/}"
          entries+=("$rel")
        done

        choice="$(
          for wallpaper in "''${WALLPAPERS[@]}"; do
            rel="''${wallpaper#"$WALLPAPER_DIR"/}"
            printf '%s\0icon\x1f%s\n' "$rel" "$wallpaper"
          done | rofi \
            -dmenu \
            -i \
            -show-icons \
            -no-custom \
            -matching fuzzy \
            -p "Wallpaper" \
            -theme-str 'element-icon { size: 5em; } element { padding: 6px; spacing: 10px; } listview { lines: 8; }'
        )" || exit 0

        [[ -n "$choice" ]] || exit 0

        for i in "''${!entries[@]}"; do
          if [[ "''${entries[$i]}" == "$choice" ]]; then
            selected="''${WALLPAPERS[$i]}"
            break
          fi
        done

        [[ -n "$selected" ]] || die "Could not resolve selection: $choice"

        apply_wallpaper "$selected"
        record_wallpaper "$selected"
        notify -i "$selected" "Wallpaper applied" "$choice"
      }

      case "''${1:-}" in
        "")
          show_menu
          ;;
        --restore)
          restore_wallpaper
          ;;
        -h | --help)
          usage
          ;;
        *)
          die "Unknown option: $1"
          ;;
      esac
    '';
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

  ########################
  ### PACKAGES YOU USE ###
  ########################
  home.packages = [
    wallpaperSwitcher
  ]
  ++ (with pkgs; [
    waybar
    wl-clipboard
    cliphist
    dunst
    libnotify
    awww
    kitty
    rofi
    networkmanagerapplet
    hyprshot
    wlsunset
  ]);

  xsession.preferStatusNotifierItems = true;

  services.cliphist = {
    enable = true;
    allowImages = true;
    systemdTargets = [ hyprlandTarget ];
    extraOptions = [
      "-max-items"
      cliphistMaxItems
    ];
  };

  services.wlsunset = {
    enable = true;
    sunrise = "07:00";
    sunset = "21:00";
    duration = 30;
    temperature = {
      night = 2000;
      day = 6500;
    };
    systemdTarget = hyprlandTarget;
  };

  services.network-manager-applet.enable = true;
  services.blueman-applet = {
    enable = true;
    systemdTargets = [ hyprlandTarget ];
  };
  services.dunst.enable = true;

  systemd.user.services = {
    dunst = {
      Unit = {
        After = lib.mkForce [ hyprlandTarget ];
        PartOf = lib.mkForce [ hyprlandTarget ];
      };
      Install.WantedBy = [ hyprlandTarget ];
    };

    network-manager-applet = {
      Unit = {
        After = lib.mkForce [
          hyprlandTarget
          "tray.target"
        ];
        PartOf = lib.mkForce [ hyprlandTarget ];
      };
      Install.WantedBy = lib.mkForce [ hyprlandTarget ];
    };

    awww-daemon = {
      Unit = {
        Description = "Awww wallpaper daemon";
        After = [ hyprlandTarget ];
        PartOf = [ hyprlandTarget ];
        ConditionEnvironment = "WAYLAND_DISPLAY";
      };

      Service = {
        ExecStart = "${pkgs.awww}/bin/awww-daemon";
        Restart = "on-failure";
      };

      Install.WantedBy = [ hyprlandTarget ];
    };

    wallpaper-restore = {
      Unit = {
        Description = "Restore Hyprland wallpaper";
        Wants = [ "awww-daemon.service" ];
        After = [
          hyprlandTarget
          "awww-daemon.service"
        ];
        PartOf = [ hyprlandTarget ];
        ConditionEnvironment = "WAYLAND_DISPLAY";
      };

      Service = {
        Type = "oneshot";
        ExecStartPre = "${pkgs.coreutils}/bin/sleep 2";
        ExecStart = "${wallpaperSwitcher}/bin/wallpaper-switcher --restore";
      };

      Install.WantedBy = [ hyprlandTarget ];
    };
  };

}
