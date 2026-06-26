{ lib, pkgs, ... }:

{
  imports = [
    ./gc.nix
    ./qol.nix
    ./responsiveness.nix
    ./vial-udev.nix
    ./kanata.nix
    ./gaming.nix
  ];

  nix.settings = {
    trusted-users = [
      "root"
      "domagoj"
    ];

    substituters = [
      "https://cache.nixos.org"
      "https://nixos-raspberrypi.cachix.org"
    ];

    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0y5B9yq9/6y2+HBCg3m3y+7tcX+4rA="
      "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
    ];

    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  nixpkgs.config.allowUnfree = true;

  boot = {
    binfmt.emulatedSystems = [ "aarch64-linux" ];

    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 8;
        editor = false;
      };
      timeout = 0;
      efi.canTouchEfiVariables = true;
    };
  };

  networking.networkmanager.enable = true;

  hardware.graphics.enable = true;
  hardware.bluetooth.enable = true;

  time.timeZone = "Europe/Zagreb";

  i18n = {
    defaultLocale = "en_US.UTF-8";

    extraLocaleSettings = {
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
  };

  services.xserver = {
    enable = true;
    xkb = {
      layout = "us,hr";
      variant = "";
    };
  };

  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "Hyprland";
      user = "domagoj";
    };
  };

  services.blueman.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.libinput.mouse.accelProfile = "flat";
  services.openssh.enable = true;

  programs = {
    zsh.enable = true;
    hyprland.enable = true;
    dconf.enable = true;
  };

  users.users.domagoj = {
    isNormalUser = true;
    description = "DomagojAlaber";
    extraGroups = lib.mkBefore [
      "networkmanager"
      "wheel"
      "docker"
    ];
    shell = pkgs.zsh;
  };

  # Let the display manager own tty1.
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  xdg.portal.enable = true;

  virtualisation.docker.enable = true;
}
