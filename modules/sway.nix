{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:

let
  mod = "Mod4";
  screenshot = pkgs.writeShellApplication {
    name = "sway-region-screenshot";
    runtimeInputs = with pkgs; [
      grim
      slurp
      wl-clipboard
    ];
    text = ''
      region=$(slurp) || exit 0
      grim -g "$region" - | wl-copy --type image/png
    '';
  };
  workspaceBindings = lib.listToAttrs (
    lib.concatMap (
      number:
      let
        key = if number == 10 then "0" else toString number;
        workspace = toString number;
      in
      [
        {
          name = "${mod}+${key}";
          value = "workspace number ${workspace}";
        }
        {
          name = "${mod}+Shift+${key}";
          value = "move container to workspace number ${workspace}; workspace number ${workspace}";
        }
      ]
    ) (lib.range 1 10)
  );
  directionBindings = lib.listToAttrs (
    lib.concatMap
      (
        direction:
        lib.concatMap (key: [
          {
            name = "${mod}+${key}";
            value = "focus ${direction.name}";
          }
          {
            name = "${mod}+Shift+${key}";
            value = "move ${direction.name}";
          }
        ]) direction.keys
      )
      [
        {
          name = "left";
          keys = [
            "h"
            "Left"
          ];
        }
        {
          name = "right";
          keys = [
            "l"
            "Right"
          ];
        }
        {
          name = "up";
          keys = [
            "k"
            "Up"
          ];
        }
        {
          name = "down";
          keys = [
            "j"
            "Down"
          ];
        }
      ]
  );
in
{
  wayland.windowManager.sway = {
    enable = true;
    # Use the same NixOS wrapper (including the laptop's NVIDIA flag).
    package = osConfig.programs.sway.package;
    systemd.enable = true;
    config = {
      modifier = mod;
      terminal = "kitty";
      menu = "rofi -show drun -show-icons";
      bars = [ ]; # Waybar is managed by systemd in both sessions.
      fonts = {
        names = [ "SpaceMono Nerd Font" ];
        size = 10.0;
      };
      gaps = {
        inner = 1;
        outer = 0;
      };
      window = {
        border = 1;
        titlebar = false;
      };
      floating = {
        border = 1;
        titlebar = false;
        modifier = mod;
      };
      focus.followMouse = true;
      colors = {
        focused = {
          border = "#9932cc";
          background = "#1e1e2e";
          text = "#cdd6f4";
          indicator = "#9932cc";
          childBorder = "#9932cc";
        };
        unfocused = {
          border = "#cba6f7";
          background = "#1e1e2e";
          text = "#cdd6f4";
          indicator = "#cba6f7";
          childBorder = "#cba6f7";
        };
        focusedInactive = config.wayland.windowManager.sway.config.colors.unfocused;
      };
      input = {
        "type:keyboard" = {
          xkb_layout = "us,hr";
          xkb_options = "grp:alt_shift_toggle";
        };
        "type:pointer" = {
          accel_profile = "flat";
          pointer_accel = "0";
        };
        "type:touchpad".natural_scroll = "disabled";
      };
      # Sway selects each output's preferred mode and arranges outputs automatically.
      output."*".scale = "1";
      seat."*".xcursor_theme = "catppuccin-mocha-dark-cursors 24";
      # Replace Sway's defaults: several overlap your Hyprland shortcuts.
      keybindings =
        workspaceBindings
        // directionBindings
        // {
          "${mod}+Return" = "exec kitty";
          "${mod}+c" = "kill";
          "${mod}+m" = "exit";
          "${mod}+e" = "exec kitty -e yazi";
          "${mod}+v" = "floating toggle";
          "${mod}+s" = "exec rofi -show drun -show-icons";
          "${mod}+o" = "exec cliphist list | rofi -dmenu | cliphist decode | wl-copy";
          "${mod}+w" = "exec wallpaper-switcher";
          "${mod}+f" = "fullscreen toggle";
          "${mod}+Print" = "exec ${screenshot}/bin/sway-region-screenshot";
          # Sway uses explicit splits rather than Hyprland's dwindle/pseudotiling.
          "${mod}+b" = "splith";
          "${mod}+n" = "splitv";
          "${mod}+a" = "focus parent";
          "${mod}+space" = "focus mode_toggle";
          "${mod}+r" = "mode resize";
          "${mod}+Shift+c" = "reload";
          "${mod}+minus" = "scratchpad show";
          "${mod}+Shift+minus" = "move scratchpad";
        };
    };
    extraConfig = ''
      default_orientation auto
      for_window [all] opacity 0.95
    '';
  };

  # Stop shared desktop services when the Sway session ends.
  systemd.user.targets.sway-session.Unit.PropagatesStopTo = [ "graphical-session.target" ];
  home.packages = [ screenshot ];
}
