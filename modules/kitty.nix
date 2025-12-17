{ ... }:

{
  programs.kitty = {
    enable = true;

    themeFile = "Catppuccin-Mocha";

    settings = {
      background_opacity = "0.90";
      cursor_shape = "beam";
    };
  };
}
