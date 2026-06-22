{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/nixos/common.nix
  ];

  networking.hostName = "laptop"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  networking.networkmanager.plugins = with pkgs; [
    networkmanager-fortisslvpn
    networkmanager-iodine
    networkmanager-l2tp
    networkmanager-openconnect
    networkmanager-openvpn
    networkmanager-sstp
    networkmanager-strongswan
    networkmanager-vpnc
  ];

  hardware.graphics.enable32Bit = true;

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {

    modesetting.enable = true;

    powerManagement.enable = true;
    powerManagement.finegrained = false;

    open = false;

    nvidiaSettings = true;

    # GTX 1060 mobile is now on the 580.xx legacy branch; newer stable drivers ignore it.
    package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
  };

  environment.sessionVariables.VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json";

  # Enable sound with pipewire and disable other services
  services.pulseaudio.enable = false;
  services.printing.enable = false;
  services.nscd.enable = true;
  services.nscd.enableNsncd = true;
  services.spice-vdagentd.enable = false;

  security.rtkit.enable = true;
  security.unprivilegedUsernsClone = true;

  programs.nix-ld.enable = true;

  users.users.domagoj.extraGroups = [
    "disk"
    "video"
  ];

  programs.hyprland.xwayland.enable = true;

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };

  environment.pathsToLink = [ "/share/zsh" ];

  #List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    nodejs
    go
    neovim
    kitty
    discord
    dbeaver-bin
    bun
    traceroute
    waybar
    eww
    dunst
    rofi
    mixxx
    swtpm
    brightnessctl
    vulkan-tools
  ];

  services.udisks2.enable = true;
  security.polkit.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  programs.ssh.startAgent = true;

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
