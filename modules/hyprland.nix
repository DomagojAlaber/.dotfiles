{ config, pkgs, inputs, ... }:

{
  # Hyprland 
  programs.hyprland.enable = true;

  environment.systemPackages = with pkgs; [
    waybar
    dunst
    libnotify
    swww
    kitty
    rofi-wayland
    networkmanagerapplet
  ]; 

  programs.waybar.enable = true;

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
}
