{
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/gc.nix
    ../../modules/nixos/responsiveness.nix
    ../../modules/nixos/vial-udev.nix
    ../../modules/nixos/kanata.nix
    ../../modules/nixos/netbird.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 8;
    editor = false;
  };
  boot.loader.timeout = 0;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "station"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
  };

  services.xserver.videoDrivers = [ "amdgpu" ];

  # Set your time zone.
  time.timeZone = "Europe/Zagreb";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "hr_HR.UTF-8";
    LC_IDENTIFICATION = "hr_HR.UTF-8";
    LC_MEASUREMENT = "hr_HR.UTF-8";
    LC_MONETARY = "hr_HR.UTF-8";
    LC_NAME = "hr_HR.UTF-8";
    LC_NUMERIC = "hr_HR.UTF-8";
    LC_PAPER = "hr_HR.UTF-8";
    LC_TELEPHONE = "hr_HR.UTF-8";
    LC_TIME = "hr_HR.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        command = "${pkgs.hyprland}/bin/Hyprland";
        user = "domagoj";
      };
    };
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us,hr";
    variant = "";
  };

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

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;
  programs.zsh.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.domagoj = {
    isNormalUser = true;
    description = "DomagojAlaber";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "gamemode"
      "vboxusers"
    ];
    shell = pkgs.zsh;
  };

  services.blueman.enable = true;
  # Let the display manager own tty1.
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [
    pkgs.xdg-desktop-portal-gtk
    pkgs.xdg-desktop-portal-hyprland
  ];

  # Install firefox.
  programs.firefox.enable = true;

  # Install Steam
  programs.steam.enable = true;

  # Gamemode
  programs.gamemode.enable = true;

  # Enable dconf (System Management Tool)
  programs.dconf.enable = true;

  # Hyprland
  programs.hyprland.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  virtualisation.virtualbox.host.enable = true;
  # If you want the networking modules too (vboxnetflt, vboxnetadp):
  virtualisation.virtualbox.host.enableExtensionPack = true;
  virtualisation.virtualbox.guest.enable = true;

  # Docker
  virtualisation.docker.enable = true;

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
    virt-manager
    virt-viewer
    spice
    spice-gtk
    spice-protocol
    virtio-win
    win-spice
    adwaita-icon-theme
    virtio-win
  ];

  services.libinput.mouse.accelProfile = "flat";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

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

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
