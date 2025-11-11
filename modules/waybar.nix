{ config, pkgs, ... }:

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
          "format" = "{icon} {text}";
          "return-type" = "json";
          "max-length" = 40;
          "format-icons" = {
            "spotify" = "";
            "default" = "🎜";
          };
          "escape" = true;
          "exec" = "$HOME/.config/waybar/mediaplayer.py 2> /dev/null";
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
    yazi
    kitty
    rofi
    hyprshot

    nerd-fonts.space-mono
  ];
}
