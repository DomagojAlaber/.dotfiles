{ ... }:

{
  zramSwap.enable = true;
  services.systemd-oomd.enable = true;
  services.earlyoom.enable = true;
}
