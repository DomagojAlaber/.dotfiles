{ ... }:

{
  programs.zed-editor = {
    enable = true;

    userSettings = {
      completions = {
        lsp_fetch_timeout_ms = 0;
      };

      context_servers = {
        "svelte-mcp" = {
          enabled = true;
          settings = { };
        };
      };

      disable_ai = false;

      notification_panel = {
        button = false;
      };

      collaboration_panel = {
        button = false;
      };

      git_panel = {
        button = true;
      };

      outline_panel = {
        file_icons = true;
        button = true;
      };

      relative_line_numbers = "enabled";

      agent = {
        play_sound_when_agent_done = true;
        dock = "left";
        button = true;
        model_parameters = [ ];
      };

      project_panel = {
        file_icons = true;
        hide_gitignore = false;
        hide_hidden = false;
        hide_root = false;
        entry_spacing = "standard";
        default_width = 240.0;
        dock = "right";
      };

      icon_theme = "Catppuccin Mocha";
      vim_mode = true;
      ui_font_size = 15;
      buffer_font_family = "Iosevka Nerd Font";
      buffer_font_size = 12;

      file_finder = {
        modal_max_width = "medium";
      };

      theme = {
        mode = "dark";
        light = "Catppuccin Latte";
        dark = "Catppuccin Mocha";
      };
    };

    userKeymaps = [
      {
        context = "Workspace";
        bindings = { };
      }
      {
        context = "Editor && vim_mode == insert";
        bindings = { };
      }
      {
        context = "ProjectPanel && not_editing";
        bindings = {
          "ctrl-u" = [
            "action::Sequence"
            [
              "project_panel::ScrollUp"
              "project_panel::ScrollCursorCenter"
            ]
          ];
          "ctrl-d" = [
            "action::Sequence"
            [
              "project_panel::ScrollDown"
              "project_panel::ScrollCursorCenter"
            ]
          ];
        };
      }
      {
        context = "VimControl && !menu";
        bindings = {
          "ctrl-u" = [
            "action::Sequence"
            [
              "vim::ScrollUp"
              "editor::ScrollCursorCenter"
            ]
          ];
          "ctrl-d" = [
            "action::Sequence"
            [
              "vim::ScrollDown"
              "editor::ScrollCursorCenter"
            ]
          ];
          "ctrl-f" = [
            "action::Sequence"
            [
              "vim::PageDown"
              "editor::ScrollCursorCenter"
            ]
          ];
          "ctrl-b" = [
            "action::Sequence"
            [
              "vim::PageUp"
              "editor::ScrollCursorCenter"
            ]
          ];
        };
      }
      {
        context = "Pane";
        bindings = {
          "ctrl-k h" = "pane::SplitLeft";
        };
      }
      {
        context = "Pane";
        bindings = {
          "ctrl-k k" = "pane::SplitUp";
        };
      }
      {
        context = "ContextEditor > Editor";
        bindings = {
          "backspace delete backspace" = "agent::OpenRulesLibrary";
        };
      }
      {
        context = "Pane";
        bindings = {
          "ctrl-k l" = "pane::SplitRight";
        };
      }
    ];
  };
}
