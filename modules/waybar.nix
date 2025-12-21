{ pkgs, ... }:

{
  programs.waybar = {
    enable = true;

    style = ''
      * {
          font-family: "SpaceMono Nerd Font";
          font-size: 12px;
      }

      window#waybar {
          background: transparent;
          border-radius: 7rem;
          color: #cba6f7;
          border-width: 2px;
          border-style: solid;
          border-color: #cba6f7;
      }

      window#waybar.empty #window {
          background-color: transparent;
          padding: 0px;
          border: 0px;
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
      #custom-media,
      #tray,
      #bluetooth,
      #mode,
      #idle_inhibitor,
      #scratchpad,
      #power-profiles-daemon,
      #language,
      #mpd {
      	background-color: transparent;
          padding: 0 10px;
          border-radius: 7rem;
      }

      #clock:hover,
      #battery:hover,
      #cpu:hover,
      #memory:hover,
      #disk:hover,
      #temperature:hover,
      #backlight:hover,
      #network:hover,
      #pulseaudio:hover,
      #wireplumber:hover,
      #custom-media:hover,
      #tray:hover,
      #mode:hover,
      #bluetooth:hover,
      #idle_inhibitor:hover,
      #scratchpad:hover,
      #power-profiles-daemon:hover,
      #language:hover,
      #mpd:hover {
          background-color: #cba6f7;
          color: #561508;
      }

      #workspaces {
        border-radius: 7rem;
        background-color: transparent;
      }

      #workspaces button {
        color: #cba6f7;
        border-radius: 7rem;
      }

      #workspaces button.active {
        color: #561508;
        background-color: #cba6f7;
        border-radius: 7rem;
      }

      #workspaces button:hover {
        color: #561508;
        background-color: #cba6f7;
        border-radius: 7rem;
      }

      #custom-arch {
      	margin-left: 5px;
          padding: 0 10px;
          font-size: 25px;
          background-color: transparent;
          border-radius: 7rem;
      }
      #custom-arch:hover {
          background-color: #cba6f7;
          color: #561508;
      }
      #custom-search {
          padding: 0 10px;
          font-size: 20px;
          background-color: transparent;
          border-radius: 7rem;
      }
      #custom-search:hover {
          background-color: #cba6f7;
          color: #561508;
      }
      #custom-power {
          margin-right: 5px;
          padding: 0 10px;
          background-color: transparent;
          border-radius: 7rem;
      }
      #custom-power:hover {
          background-color: #cba6f7;
          color: #561508;
      }

      #window {
        border-radius: 7rem;
        padding: 0 10px;
        background-color: transparent;
      }
      #window:hover {
          background-color: #cba6f7;
          color: #561508;
      }

      #pulseaudio-slider slider {
      	min-width: 0px;
      	min-height: 0px;
      	opacity: 0;
      	background-image: none;
      	border: none;
      	box-shadow: none;
      }

      #pulseaudio-slider trough {
      	min-width: 80px;
      	min-height: 5px;
      	border-radius: 7rem;
      }

      #pulseaudio-slider highlight {
      	min-height: 10px;
      	border-radius: 7rem;
      }

      #backlight-slider slider {
      	min-width: 0px;
      	min-height: 0px;
      	opacity: 0;
      	background-image: none;
      	border: none;
      	box-shadow: none;
      }

      #backlight-slider trough {
      	min-width: 80px;
      	min-height: 10px;
      	border-radius: 7rem;
      }

      #backlight-slider highlight {
      	min-width: 10px;
      	border-radius: 7rem;
      }

      #mpris {
      	border-radius: 7rem;
      	background-color: transparent;
      	padding: 0 10px;
      }
      #mpris:hover {
          background-color: #cba6f7;
          color: #561508;
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
        ];
        "modules-right" = [
          "pulseaudio"
          "network"
          "cpu"
          "memory"
          "backlight"
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

        # If you ever use them, you can add sway/mode & sway/scratchpad here.

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
    swww
    wlsunset
    kitty
    rofi
    hyprshot

    nerd-fonts.space-mono
    python3
    playerctl
  ];

  ############################
  ##  WAYBAR SUPPORT FILES  ##
  ############################
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
      <menu id="power-menu">
        <item label="Suspend" action="suspend"/>
        <item label="Hibernate" action="hibernate"/>
        <item label="Reboot" action="reboot"/>
        <item label="Shutdown" action="shutdown"/>
      </menu>
    '';
  };
}
