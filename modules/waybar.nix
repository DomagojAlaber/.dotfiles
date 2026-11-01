{
  config,
  lib,
  pkgs,
  ...
}:

let
  waybarPomodoro = pkgs.rustPlatform.buildRustPackage rec {
    pname = "waybar-module-pomodoro";
    version = "0.3.0-unstable-2026-08-28";

    src = pkgs.fetchFromGitHub {
      owner = "Andeskjerf";
      repo = pname;
      rev = "3867b25ab691c4a697ee2ffca76d7cc9408675cc";
      hash = "sha256-vB5WROn/GmaJyLNHnyfhTZItjQlJ+LMXMw8gOT1GM0s=";
    };

    cargoHash = "sha256-FTzqNkGn1dk+pdee8U07NI/uqUR6/gs51ZWOpYro3j8=";

    preCheck = ''
      export HOME=$TMPDIR
    '';

    dontUseCargoParallelTests = true;

    meta = {
      description = "Pomodoro timer module for Waybar";
      homepage = "https://github.com/Andeskjerf/waybar-module-pomodoro";
      license = pkgs.lib.licenses.unlicense;
      mainProgram = pname;
    };
  };

  pomodoroCommand = "${waybarPomodoro}/bin/waybar-module-pomodoro --persist --work 50 --shortbreak 10 --longbreak 30 --intervals 4";
  # Reuse the bar styling and desktop modules, selecting compositor-specific
  # workspace, mode and keyboard modules when the session starts.
  swayBarConfig = (pkgs.formats.json { }).generate "waybar-sway.json" (
    map (
      bar:
      (builtins.removeAttrs bar [
        "hyprland/workspaces"
        "hyprland/submap"
        "hyprland/language"
      ])
      // {
        # Keep tiled windows below the bar and reserve its actual height.
        layer = "top";
        position = "top";
        exclusive = true;
        modules-left = [
          "sway/workspaces"
          "sway/mode"
          "custom/media"
        ];
        modules-right = map (
          name: if name == "hyprland/language" then "sway/language" else name
        ) bar.modules-right;
        "sway/workspaces" = {
          disable-scroll = true;
        };
        "sway/mode" = {
          format = "{}";
        };
        "sway/language" = {
          format = "{short}";
        };
      }
    ) config.programs.waybar.settings
  );
  startWaybar = pkgs.writeShellScript "start-waybar" ''
    case ":''${XDG_CURRENT_DESKTOP:-}:" in
      *:sway:*) exec ${pkgs.waybar}/bin/waybar --config ${swayBarConfig} ;;
      *) exec ${pkgs.waybar}/bin/waybar ;;
    esac
  '';

in

{
  xdg.configFile."waybar/sway.json".source = swayBarConfig;
  systemd.user.services.waybar = {
    Service.ExecStart = lib.mkForce "${startWaybar}";
    Unit.PartOf = lib.mkForce config.programs.waybar.systemd.targets;
    Install.WantedBy = lib.mkForce config.programs.waybar.systemd.targets;
  };

  programs.waybar = {
    enable = true;

    systemd = {
      enable = true;
      targets = [
        "hyprland-session.target"
        "sway-session.target"
      ];
    };

    style = ''
      @import "mocha.css";

      * {
          font-family: "IosevkaTerm Nerd Font";
          font-size: 14px;
          min-height: 0;
      }

      window#waybar {
          background: alpha(@base, 0.92);
          color: @text;
          border: none;
          border-bottom: 1px solid @surface0;
          border-radius: 0;
      }

      button {
          min-width: 0;
          padding: 0 10px;
          border: none;
          border-radius: 3px;
          background: transparent;
          box-shadow: none;
          text-shadow: none;
          color: @subtext0;
      }

      button:hover {
          background: @surface0;
          color: @text;
      }

      #clock,
      #battery,
      #cpu,
      #memory,
      #disk,
      #temperature,
      #backlight,
      #network,
      #pulseaudio,
      #wireplumber,
      #custom-pomodoro,
      #custom-media,
      #custom-arch,
      #custom-search,
      #custom-power,
      #tray,
      #bluetooth,
      #mode,
      #idle_inhibitor,
      #scratchpad,
      #power-profiles-daemon,
      #keyboard-state,
      #language,
      #window,
      #mpd {
          padding: 0 10px;
          border-radius: 3px;
          background: transparent;
          color: @text;
      }

      #clock:hover,
      #custom-pomodoro:hover,
      #custom-media:hover,
      #custom-arch:hover,
      #custom-search:hover,
      #custom-power:hover,
      #pulseaudio:hover,
      #network:hover,
      #battery:hover,
      #tray:hover {
          background: @surface0;
      }

      #workspaces button.active,
      #workspaces button.focused {
          background: transparent;
          color: @text;
          box-shadow: inset 0 -2px @text;
      }

      #workspaces button.urgent {
          color: @red;
      }

      #battery.warning:not(.charging) {
          color: @yellow;
      }

      #battery.critical:not(.charging) {
          color: @red;
      }

      #custom-pomodoro.pause {
          color: @subtext0;
      }

      #pulseaudio-slider slider,
      #backlight-slider slider {
          min-width: 0;
          min-height: 0;
          opacity: 0;
          background-image: none;
          border: none;
          box-shadow: none;
      }

      #pulseaudio-slider trough,
      #backlight-slider trough {
          min-width: 60px;
          min-height: 4px;
          border-radius: 2px;
          background: @surface0;
      }

      #pulseaudio-slider highlight,
      #backlight-slider highlight {
          min-height: 4px;
          border-radius: 2px;
          background: @subtext0;
      }
    '';

    ##########################
    ##  CONFIG AS NIX
    ##########################
    settings = [
      {
        "height" = 30;
        "spacing" = 4;

        # modules
        "modules-left" = [
          "hyprland/workspaces"
          "hyprland/submap"
          "custom/media"
        ];
        "modules-center" = [
          "clock"
          "custom/pomodoro"
        ];
        "modules-right" = [
          "pulseaudio"
          "network"
          "cpu"
          "memory"
          "battery"
          "keyboard-state"
          "hyprland/language"
          "tray"
          "custom/power"
        ];

        ###################
        # module configs
        ###################

        "keyboard-state" = {
          "numlock" = true;
          "capslock" = true;
          "format" = "{name} {icon}";
          "format-icons" = {
            "locked" = "";
            "unlocked" = "";
          };
        };

        "hyprland/workspaces" = {
          "show-special" = true;
        };

        "idle_inhibitor" = {
          "format" = "{icon}";
          "format-icons" = {
            "activated" = "";
            "deactivated" = "";
          };
        };

        "tray" = {
          "spacing" = 10;
        };

        "clock" = {
          "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          "format-alt" = "{:%Y-%m-%d}";
        };

        "cpu" = {
          "format" = "{usage}% ";
          "tooltip" = false;
        };

        "memory" = {
          "format" = "{}% ";
        };

        "temperature" = {
          "critical-threshold" = 80;
          "format" = "{temperatureC}°C {icon}";
          "format-icons" = [
            ""
            ""
            ""
          ];
        };

        "backlight" = {
          "format" = "{percent}% {icon}";
          "format-icons" = [
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
          ];
        };

        "battery" = {
          "states" = {
            "warning" = 30;
            "critical" = 15;
          };
          "format" = "{capacity}% {icon}";
          "format-full" = "{capacity}% {icon}";
          "format-charging" = "{capacity}% ";
          "format-plugged" = "{capacity}% ";
          "format-alt" = "{time} {icon}";
          "format-icons" = [
            ""
            ""
            ""
            ""
            ""
          ];
        };

        "battery#bat2" = {
          "bat" = "BAT2";
        };

        "power-profiles-daemon" = {
          "format" = "{icon}";
          "tooltip-format" = "Power profile: {profile}\nDriver: {driver}";
          "tooltip" = true;
          "format-icons" = {
            "default" = "";
            "performance" = "";
            "balanced" = "";
            "power-saver" = "";
          };
        };

        "network" = {
          "format-wifi" = "{essid} ({signalStrength}%) ";
          "format-ethernet" = "{ipaddr}/{cidr} ";
          "tooltip-format" = "{ifname} via {gwaddr} ";
          "format-linked" = "{ifname} (No IP) ";
          "format-disconnected" = "Disconnected ⚠";
          "format-alt" = "{ifname}: {ipaddr}/{cidr}";
        };

        "pulseaudio" = {
          "format" = "{volume}% {icon} {format_source}";
          "format-bluetooth" = "{volume}% {icon} {format_source}";
          "format-bluetooth-muted" = " {icon} {format_source}";
          "format-muted" = " {format_source}";
          "format-source" = "{volume}% ";
          "format-source-muted" = "";
          "format-icons" = {
            "headphone" = "";
            "hands-free" = "";
            "headset" = "";
            "phone" = "";
            "portable" = "";
            "car" = "";
            "default" = [
              ""
              ""
              ""
            ];
          };
          "on-click" = "pavucontrol";
        };

        "custom/media" = {
          "format" = " {text}";
          "return-type" = "json";
          "max-length" = 40;
          "escape" = true;
          "exec" = "$HOME/.config/waybar/mediaplayer.py --player spotify 2> /dev/null";
        };

        "custom/pomodoro" = {
          "format" = "{}";
          "return-type" = "json";
          "exec" = pomodoroCommand;
          "on-click" = "${pomodoroCommand} toggle";
          "on-click-right" = "${pomodoroCommand} reset";
        };

        "custom/power" = {
          "format" = "⏻ ";
          "tooltip" = false;
          "menu" = "on-click";
          "menu-file" = "$HOME/.config/waybar/power_menu.xml";
          "menu-actions" = {
            "shutdown" = "shutdown";
            "reboot" = "reboot";
            "suspend" = "systemctl suspend";
            "hibernate" = "systemctl hibernate";
          };
        };
      }
    ];
  };

  ############################
  ##  PACKAGES / FONTS
  ############################
  home.packages = with pkgs; [
    waybar
    wl-clipboard
    cliphist
    networkmanagerapplet
    wlsunset
    kitty
    rofi
    hyprshot

    nerd-fonts.space-mono
    python3
    playerctl
    waybarPomodoro
  ];

  ############################
  ##  WAYBAR SUPPORT FILES  ##
  ############################
  home.file.".config/waybar/mocha.css".source = ../themes/waybar/mocha.css;

  home.file.".config/waybar/mediaplayer.py" = {
    text = ''
      #!/usr/bin/env python3

      import argparse
      import json
      import subprocess
      import sys
      import time

      FORMAT = "{{status}}|{{playerName}}|{{xesam:title}}|{{xesam:artist}}"
      POLL_INTERVAL = 2

      def query_metadata(player=None):
          try:
              command = ["playerctl"]
              if player:
                  command += ["--player", player]
              else:
                  command += ["-a"]
              command += ["metadata", "--format", FORMAT]

              result = subprocess.run(
                  command,
                  check=False,
                  capture_output=True,
                  text=True,
              )
          except FileNotFoundError:
              return None, "playerctl missing"

          if result.returncode != 0 or not result.stdout.strip():
              return None, None

          entries = []
          for raw in result.stdout.splitlines():
              raw = raw.strip()
              if not raw:
                  continue
              parts = raw.split("|", 3)
              if len(parts) != 4:
                  continue
              status, player_name, title, artist = parts
              entries.append(
                  {
                      "status": status,
                      "player": player_name,
                      "title": title,
                      "artist": artist,
                  }
              )
          if not entries:
              return None, None

          playing = next((entry for entry in entries if entry["status"] == "Playing"), None)
          return (playing or entries[0]), None

      def payload(entry, message=None):
          if message:
              text = message
              tooltip = message
              css_class = "error"
              alt = "error"
          elif entry is None:
              text = "No player"
              tooltip = "No active media players"
              css_class = "idle"
              alt = "idle"
          else:
              artist = entry["artist"].strip()
              title = entry["title"].strip()
              text = title if not artist else f"{artist} - {title}"
              tooltip = text
              css_class = entry["status"].lower()
              alt = entry["player"]

          return {
              "text": text,
              "tooltip": tooltip,
              "class": css_class,
              "alt": alt,
          }

      def main():
          parser = argparse.ArgumentParser(add_help=False)
          parser.add_argument("--player", dest="player", default=None)
          args = parser.parse_args()

          last = None
          while True:
              entry, error = query_metadata(args.player)
              data = payload(entry, error)
              serialized = json.dumps(data, ensure_ascii=False)
              if serialized != last:
                  print(serialized, flush=True)
                  last = serialized
              time.sleep(POLL_INTERVAL)

      if __name__ == "__main__":
          try:
              main()
          except KeyboardInterrupt:
              sys.exit(0)
    '';
    executable = true;
  };

  home.file.".config/waybar/power_menu.xml" = {
    text = ''
      <?xml version="1.0" encoding="UTF-8"?>
      <interface>
        <object class="GtkMenu" id="menu">
          <child>
            <object class="GtkMenuItem" id="suspend">
              <property name="label">Suspend</property>
            </object>
          </child>
          <child>
            <object class="GtkMenuItem" id="hibernate">
              <property name="label">Hibernate</property>
            </object>
          </child>
          <child>
            <object class="GtkMenuItem" id="reboot">
              <property name="label">Reboot</property>
            </object>
          </child>
          <child>
            <object class="GtkMenuItem" id="shutdown">
              <property name="label">Shutdown</property>
            </object>
          </child>
        </object>
      </interface>
    '';
  };
}
