{
  pkgs,
  lib,
  ...
}:

let
  cursorThemeName = "catppuccin-mocha-dark-cursors";
  cursorSize = 24;
  gtkThemeName = "catppuccin-mocha-mauve-standard+normal";
  gtkThemePackage = pkgs.catppuccin-gtk.override {
    variant = "mocha";
    accents = [ "mauve" ];
    size = "standard";
    tweaks = [ "normal" ];
  };

  importAllNix =
    dir:
    let
      files = builtins.readDir dir;
      nixFiles = lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".nix" name) files;
    in
    map (name: dir + "/${name}") (builtins.attrNames nixFiles);
in
{
  imports = importAllNix ./modules;

  home.username = "domagoj";
  home.homeDirectory = "/home/domagoj";

  home.stateVersion = "24.11"; # DO NOT CHANGE THIS VALUE.

  programs.chromium = {
    enable = true;
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };

    "org/gnome/desktop/a11y/applications" = {
      screen-reader-enabled = false;
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = gtkThemeName;
      icon-theme = "Papirus-Dark";
      cursor-theme = cursorThemeName;
      cursor-size = cursorSize;
    };
  };

  gtk = {
    enable = true;

    theme = {
      package = gtkThemePackage;
      name = gtkThemeName;
    };
    iconTheme = {
      package = pkgs.catppuccin-papirus-folders;
      name = "Papirus-Dark";
    };
    cursorTheme = {
      package = pkgs.catppuccin-cursors.mochaDark;
      name = cursorThemeName;
      size = cursorSize;
    };

    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk4 = {
      theme = {
        package = gtkThemePackage;
        name = gtkThemeName;
      };
      extraConfig.gtk-application-prefer-dark-theme = 1;
    };
  };

  services.ssh-agent.enable = true;

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings."*" = {
      ForwardAgent = false;
      AddKeysToAgent = "yes";
      Compression = false;
      ServerAliveInterval = 0;
      ServerAliveCountMax = 3;
      HashKnownHosts = false;
      UserKnownHostsFile = "~/.ssh/known_hosts";
      ControlMaster = "no";
      ControlPath = "~/.ssh/master-%r@%n:%p";
      ControlPersist = "no";
    };
  };

  home.pointerCursor = {
    package = pkgs.catppuccin-cursors.mochaDark;
    name = cursorThemeName;
    size = cursorSize;
    gtk.enable = true;
    x11.enable = true;
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    kitty
    wget
    fastfetch
    git
    go
    gopls
    gotools
    gomodifytags
    delve
    nodejs
    neovim
    discord
    dbeaver-bin
    bun
    traceroute
    bash
    zsh
    lshw
    seahorse
    sqlite
    gcc
    libgcc
    tmux
    drawio
    postman
    uv
    dxvk
    xdg-desktop-portal-gtk
    adwaita-qt
    libsForQt5.qt5ct
    protonup-qt
    air
    lazygit
    nerd-fonts.jetbrains-mono
    nerd-fonts.space-mono
    nerd-fonts.iosevka
    nerd-fonts.iosevka-term
    nerd-fonts.zed-mono
    wlsunset
    davinci-resolve
    obsidian
    pamixer
    pavucontrol
    nettools
    nicotine-plus
    brave
    ngrok
    ffmpeg
    nixd
    killall
    svelte-language-server
    typescript-language-server
    prettier
    eslint_d
    gitflow
    nixfmt
    vial
    php
    ripgrep
    jq
    curl
    unzip
    zip
    tree
    btop
    bat
    eza
    gh
    sqlc
    typescript
    networkmanagerapplet
    ppp
    openssl
    obs-studio
    vlc
    spicetify-cli
    stripe-cli
    apidog
    anki
    devenv
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
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  programs.home-manager.enable = true;
}
