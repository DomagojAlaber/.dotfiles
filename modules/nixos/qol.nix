{ ... }:

{
  programs.command-not-found.enable = false;
  programs.nix-index.enable = true;

  services.fwupd.enable = true;
}
