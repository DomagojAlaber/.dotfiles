{ ... }:

{
  programs.kitty = {
    enable = true;

    font.name = "IosevkaTerm Nerd Font";
    themeFile = "Catppuccin-Mocha";

    settings = {
      background_opacity = "0.90";
      cursor_shape = "beam";
    };
  };
}
