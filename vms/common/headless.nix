{ pkgs, ... }:

{
  networking.useDHCP = false;
  networking.useNetworkd = true;
  systemd.network.enable = true;
  systemd.network.networks."10-microvm" = {
    matchConfig.Name = "en* eth*";
    networkConfig = {
      DHCP = "ipv4";
      IPv6AcceptRA = true;
    };
  };

  services.openssh = {
    enable = true;
    settings = {
      KbdInteractiveAuthentication = false;
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  networking.firewall.allowedTCPPorts = [ 22 ];

  users.users.domagoj = {
    isNormalUser = true;
    description = "DomagojAlaber";
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keyFiles = [ ../ssh/domagoj.pub ];
    shell = pkgs.zsh;
  };

  security.sudo.wheelNeedsPassword = false;
  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    curl
    git
    neovim
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.stateVersion = "24.11";
}
