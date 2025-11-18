{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;

    themeFile = "Catppuccin-Mocha";

    settings = {
      background_opacity = "0.95";
      cursor_shape = "beam";
    };
  };    

}
