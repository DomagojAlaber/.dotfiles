{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # cd into dirs by just typing their name
    autocd = true;

    # keep zsh configs under XDG
    dotDir = ".config/zsh";

    history = {
      size = 20000;
      save = 20000;
      path = "${config.xdg.dataHome}/zsh/history";
      share = true;
      ignoreDups = true;
      ignoreAllDups = true;
      extended = true;
    };

    shellAliases = {
      # ls
      ls  = "ls --color=auto";
      ll  = "ls -lh";
      la  = "ls -A";
      l   = "ls -CF";

      # git
      g   = "git";
      ga  = "git add";
      gc  = "git commit";
      gst = "git status -sb";
      gl  = "git log --oneline --graph --decorate";

      # nix
      update = "sudo nixos-rebuild switch --flake";
      nhist  = "nix profile history"; # example extra

      # misc
      cls   = "clear";
      grep  = "grep --color=auto";
    };

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      PAGER  = "less -R";
      LESSHISTFILE = "-";
    };

    initContent = ''
      # --- keybindings ---
      bindkey -v                 # vi mode
      export KEYTIMEOUT=1

      # --- completion setup ---
      autoload -Uz compinit
      zmodload zsh/complist

      _compdump="${config.xdg.cacheHome}/zsh/zcompdump"
      mkdir -p "$(dirname "$_compdump")"
      compinit -d "$_compdump"

      setopt menu_complete auto_menu complete_in_word
      setopt glob_dots numeric_glob_sort

      zstyle ':completion:*' menu select
      zstyle ':completion:*' matcher-list \
        'm:{a-z}={A-Z}' \
        'r:|[._-]=* r:|=*' \
        'l:|=* r:|=*'

      # --- history behaviour ---
      setopt hist_ignore_space   # ignore cmds starting with space
      setopt hist_verify         # show before running with !cmd
      setopt share_history       # share between zsh instances
      setopt inc_append_history  # append as you go

      # --- git-aware prompt using built-in vcs_info ---
      autoload -Uz vcs_info
      zstyle ':vcs_info:git:*' formats '%F{blue}(%b)%f '
      zstyle ':vcs_info:*' enable git'';
  };

  # Optional but highly recommended to go with this Zsh setup:

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
}
