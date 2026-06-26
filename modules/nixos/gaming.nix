{
  pkgs,
  ...
}:

{
  programs.steam = {
    enable = true;

    protontricks.enable = true;

    gamescopeSession.enable = false;
  };

  hardware.steam-hardware.enable = true;

  programs.gamemode.enable = true;

  programs.gamescope.enable = true;

  environment.systemPackages = with pkgs; [
    lutris

    protonup-qt
    winetricks
    wineWow64Packages.stable

    mangohud
    goverlay

    gamescope
  ];
}
