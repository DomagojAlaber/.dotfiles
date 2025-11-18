{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletions = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -l";
      update = "sudo nixos-rebuild switch";
    };
    history.size = 10000;
  };
}