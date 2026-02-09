{ ... }:

{
  programs.qutebrowser = {
    enable = true;
    settings = {
      tabs.position = "left";
      tabs.favicons.show = "always";
      tabs.title.format = "";
      tabs.title.format_pinned = "";
      tabs.width = 44;
      colors.webpage.darkmode.enabled = true;
      colors.webpage.preferred_color_scheme = "dark";
    };
  };
}
