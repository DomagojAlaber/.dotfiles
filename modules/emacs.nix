{ pkgs, ... }:

{
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-pgtk;

    extraPackages =
      epkgs: with epkgs; [
        catppuccin-theme
        evil
        evil-collection
        which-key
      ];

    extraConfig = ''
      (setq inhibit-startup-screen t
            initial-scratch-message nil
            ring-bell-function 'ignore
            make-backup-files nil
            auto-save-default nil
            create-lockfiles nil)

      (menu-bar-mode -1)
      (tool-bar-mode -1)
      (scroll-bar-mode -1)
      (global-display-line-numbers-mode 1)
      (column-number-mode 1)
      (show-paren-mode 1)
      (save-place-mode 1)
      (global-auto-revert-mode 1)
      (which-key-mode 1)

      (setq-default indent-tabs-mode nil
                    tab-width 2)

      (setq catppuccin-flavor 'mocha)
      (load-theme 'catppuccin :no-confirm)

      (set-face-attribute 'default nil :font "Iosevka Nerd Font" :height 120)
      (set-face-attribute 'fixed-pitch nil :font "Iosevka Nerd Font" :height 120)
      (add-to-list 'initial-frame-alist '(font . "Iosevka Nerd Font-12"))
      (add-to-list 'default-frame-alist '(font . "Iosevka Nerd Font-12"))

      (setq evil-want-integration t
            evil-want-keybinding nil
            evil-want-C-u-scroll t
            evil-want-C-i-jump nil
            evil-undo-system 'undo-redo)
      (require 'evil)
      (evil-mode 1)

      (require 'evil-collection)
      (evil-collection-init)
    '';
  };
}
