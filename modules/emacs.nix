{ pkgs, ... }:

{
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-pgtk;

    extraPackages =
      epkgs: with epkgs; [
        catppuccin-theme
        company
        evil
        evil-collection
        flycheck
        go-mode
        json-mode
        lsp-mode
        lsp-ui
        markdown-mode
        nix-mode
        svelte-mode
        typescript-mode
        web-mode
        which-key
        yasnippet
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

      (require 'company)
      (setq company-idle-delay 0.1
            company-minimum-prefix-length 1
            company-tooltip-align-annotations t)
      (global-company-mode 1)

      (require 'flycheck)
      (global-flycheck-mode 1)

      (require 'yasnippet)
      (yas-global-mode 1)

      (require 'lsp-mode)
      (require 'lsp-ui)
      (setq lsp-keymap-prefix "C-c l"
            lsp-completion-provider :capf
            lsp-enable-snippet t
            lsp-headerline-breadcrumb-enable nil
            lsp-idle-delay 0.35
            lsp-log-io nil
            lsp-prefer-flymake nil)
      (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
      (add-hook 'lsp-mode-hook #'lsp-ui-mode)

      (setq lsp-go-gopls-server-path "gopls"
            lsp-nix-nixd-server-path "nixd"
            lsp-clients-typescript-tls-path "typescript-language-server")

      (add-to-list 'auto-mode-alist '("\\.nix\\'" . nix-mode))
      (add-to-list 'auto-mode-alist '("\\.go\\'" . go-mode))
      (add-to-list 'auto-mode-alist '("go\\.mod\\'" . go-dot-mod-mode))
      (add-to-list 'auto-mode-alist '("go\\.work\\'" . go-dot-work-mode))
      (add-to-list 'auto-mode-alist '("\\.svelte\\'" . svelte-mode))
      (add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-mode))
      (add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))

      (setq js-indent-level 2
            typescript-indent-level 2
            web-mode-code-indent-offset 2
            web-mode-css-indent-offset 2
            web-mode-markup-indent-offset 2)

      (add-hook 'nix-mode-hook #'lsp-deferred)
      (add-hook 'go-mode-hook #'lsp-deferred)
      (add-hook 'go-mode-hook
                (lambda ()
                  (setq tab-width 4)
                  (add-hook 'before-save-hook #'gofmt-before-save nil t)))
      (add-hook 'svelte-mode-hook #'lsp-deferred)
      (add-hook 'typescript-mode-hook #'lsp-deferred)
      (add-hook 'js-mode-hook #'lsp-deferred)
      (add-hook 'web-mode-hook #'lsp-deferred)
    '';
  };
}
