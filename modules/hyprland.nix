{ config, pkgs, inputs, ... }:

{
  # Hyprland 
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  home.packages = with pkgs; [
    waybar
    wl-clipboard   # provides wl-paste / wl-copy
    cliphist       # provides the cliphist CLI
    dunst
    libnotify
    swww
    kitty
    rofi
    networkmanagerapplet
    hyprshot
  ]; 
}
