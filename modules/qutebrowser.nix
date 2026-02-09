{ ... }:

{
  programs.qutebrowser = {
    enable = true;
    settings = {
      tabs.position = "left";
      colors.webpage.darkmode.enabled = true;
      colors.webpage.preferred_color_scheme = "dark";
    };
  };
}
