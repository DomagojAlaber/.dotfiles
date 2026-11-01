{ lib, pkgs, ... }:

# Desktop tools shared by the Hyprland and Sway sessions.
let
  desktopTarget = "graphical-session.target";
  cliphistMaxItems = "9223372036854775807";

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
    systemdTargets = [ desktopTarget ];
    extraOptions = [
      "-max-items"
      cliphistMaxItems
    ];
  };

  services.wlsunset = {
    enable = true;
    sunrise = "07:00";
    sunset = "20:30";
    duration = 30;
    temperature = {
      night = 2000;
      day = 6500;
    };
    systemdTarget = desktopTarget;
  };

  services.network-manager-applet.enable = true;
  services.blueman-applet = {
    enable = true;
    systemdTargets = [ desktopTarget ];
  };
  services.dunst.enable = true;

  systemd.user.services = {
    dunst = {
      Unit = {
        After = lib.mkForce [ desktopTarget ];
        PartOf = lib.mkForce [ desktopTarget ];
      };
      Install.WantedBy = [ desktopTarget ];
    };

    network-manager-applet = {
      Unit = {
        After = lib.mkForce [
          desktopTarget
          "tray.target"
        ];
        PartOf = lib.mkForce [ desktopTarget ];
      };
      Install.WantedBy = lib.mkForce [ desktopTarget ];
    };

    awww-daemon = {
      Unit = {
        Description = "Awww wallpaper daemon";
        After = [ desktopTarget ];
        PartOf = [ desktopTarget ];
        ConditionEnvironment = "WAYLAND_DISPLAY";
      };

      Service = {
        ExecStart = "${pkgs.awww}/bin/awww-daemon";
        Restart = "on-failure";
      };

      Install.WantedBy = [ desktopTarget ];
    };

    wallpaper-restore = {
      Unit = {
        Description = "Restore desktop wallpaper";
        Wants = [ "awww-daemon.service" ];
        After = [
          desktopTarget
          "awww-daemon.service"
        ];
        PartOf = [ desktopTarget ];
        ConditionEnvironment = "WAYLAND_DISPLAY";
      };

      Service = {
        Type = "oneshot";
        ExecStartPre = "${pkgs.coreutils}/bin/sleep 2";
        ExecStart = "${wallpaperSwitcher}/bin/wallpaper-switcher --restore";
      };

      Install.WantedBy = [ desktopTarget ];
    };
  };

}
