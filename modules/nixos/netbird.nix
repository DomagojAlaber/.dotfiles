{ ... }:
{
  services.netbird.clients.wt0 = {
    port = 51820;

    # set true if you want the GUI client integration
    ui.enable = true;

    openFirewall = true;
    openInternalFirewall = true;
  };

  services.resolved.enable = true; # for NetBird DNS
}
