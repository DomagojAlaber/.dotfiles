{ config, pkgs, ... }:

{
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

  programs.git = {
    enable = true;
    userName = "Domagoj";
    userEmail = "a.domagoj@hotmail.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  programs.yazi = {
    enable = true;
    settings = {
      manager = {
        ratio = [
          1
          4
          3
        ];
        sort_by = "natural";
        sort_sensitive = true;
        sort_reverse = false;
        sort_dir_first = true;
        linemode = "none";
        show_hidden = true;
        show_symlink = true;
      };

      preview = {
        image_filter = "lanczos3";
        image_quality = 90;
        tab_size = 1;
        max_width = 600;
        max_height = 900;
        cache_dir = "";
        ueberzug_scale = 1;
        ueberzug_offset = [
          0
          0
          0
          0
        ];
      };

      tasks = {
        micro_workers = 5;
        macro_workers = 10;
        bizarre_retry = 5;
      };
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
    whatsapp-for-linux
    neovim
    thunderbird
    libreoffice
    discord
    pgadmin4
    dbeaver-bin
    bun
    notepad-next
    traceroute
    blender
    vscode
    lutris
    protonplus
    spotify
    bash
    zsh
    lshw
    fastfetch
    seahorse
    libgcc
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
    wlsunset
    davinci-resolve
    obsidian
    pamixer
    pavucontrol
    nettools
    nicotine-plus
    brave
    ngrok
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
