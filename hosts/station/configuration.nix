{
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/common.nix
    ../../modules/nixos/virtualization.nix
  ];

  networking.hostName = "station"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  services.xserver.videoDrivers = [ "amdgpu" ];

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.printing.drivers = with pkgs; [
    hplip # open‑source HP driver
    hplipWithPlugin # includes HP’s proprietary plugin for full feature support
  ];

  services.avahi = {
    enable = true;
    nssmdns4 = true; # lets the system resolve *.local via Avahi/Multicast DNS
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  users.users.domagoj.extraGroups = [ "gamemode" ];

  xdg.portal.extraPortals = [
    pkgs.xdg-desktop-portal-gtk
    pkgs.xdg-desktop-portal-hyprland
  ];

  # Install Steam
  programs.steam.enable = true;

  # Gamemode
  programs.gamemode.enable = true;

  #List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    git
    nodejs
    go
    neovim
    kitty
    discord
    dbeaver-bin
    bun
    traceroute
    adwaita-icon-theme
    mixxx
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
