{ config, pkgs, lib, inputs, ... }:

let
  # importAllNix: path -> [ path ]
  # Returns a list of all .nix files in the given directory (non-recursive).
  importAllNix = dir:
    let
      files = builtins.readDir dir;
      # keep only regular files that end with ".nix"
      nixFiles = lib.filterAttrs (name: type:
        type == "regular" && lib.hasSuffix ".nix" name
      ) files;
    in
      map (name: dir + "/${name}") (builtins.attrNames nixFiles);
in
{
  # This will import every .nix file from ./modules
  imports = importAllNix ./modules;
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  # TODO: Please make this file the "master file" 
  # and move all modules into some folder and pick them up into this one.

  home.username = "domagoj";
  home.homeDirectory = "/home/domagoj";

  home.stateVersion = "24.11"; # DO NOT CHANGE THIS VALUE.
  
  programs.chromium = {
    enable = true;
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Adwaita-dark";
      icon-theme = "Adwaita";
      cursor-theme = "Adwaita";
    };
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    vim
    kitty
    htop
    wget
    neofetch
    vscode
    git
    go
    nodejs
    zapzap
    neovim
    thunderbird
    libreoffice
    discord
    pgadmin4
    dbeaver-bin
    bun
    notepad-next
    traceroute
    vscode
    bash
    zsh
    lshw
    fastfetch
    seahorse
    sqlite
    gcc
    libgcc
    tmux
    drawio
    jdk
    sweethome3d.application
    postman
    uv
    dxvk
    adwaita-qt
    libsForQt5.qt5ct
    protonup-qt
    air
    lazygit
    cliphist
    nerd-fonts.jetbrains-mono
    nerd-fonts.space-mono
    wlsunset
    davinci-resolve
    obsidian
    pamixer
    pavucontrol
    nettools
    nicotine-plus
    brave
    ngrok
    flutter
    codex
    spotify
  ];


  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/domagoj/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
