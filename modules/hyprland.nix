{ config, pkgs, inputs, ... }:

{
  # Hyprland 
  programs.hyprland.enable = true;

  environment.systemPackages = with pkgs; [
    waybar
    wl-clipboard   # provides wl-paste / wl-copy
    cliphist       # provides the cliphist CLI
    dunst
    libnotify
    swww
    kitty
    rofi-wayland
    networkmanagerapplet
  ]; 
}
