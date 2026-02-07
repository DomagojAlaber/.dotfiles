{ ... }:

{
  home.file.".config/rofi/config.rasi".text = ''
    configuration {
      modi: "drun,run,window";
      show-icons: true;
      icon-theme: "Adwaita";
      font: "IosevkaTerm Nerd Font 12";
      matching: "fuzzy";
      sort: true;
      drun-display-format: "{icon} {name}";
      window-format: "{w} - {c} - {t}";
      display-drun: "Apps";
      display-run: "Run";
      display-window: "Windows";
    }

    @theme "amethyst"
  '';

  home.file.".config/rofi/themes/amethyst.rasi".text = ''
    * {
      bg: #0f0f16;
      bg-alt: #17172a;
      bg-alt-2: #1f1f35;
      fg: #e6e1e8;
      fg-muted: #b9a6d4;
      accent: #cba6f7;
      accent-strong: #9932cc;
      border: #cba6f7;

      font: "IosevkaTerm Nerd Font 12";
    }

    window {
      transparency: "real";
      background-color: #0f0f16cc;
      border: 2px;
      border-color: @border;
      border-radius: 14px;
      padding: 18px;
    }

    mainbox {
      spacing: 12px;
    }

    inputbar {
      background-color: @bg-alt;
      border-radius: 12px;
      padding: 10px 12px;
    }

    prompt {
      text-color: @accent;
      margin: 0px 8px 0px 0px;
    }

    entry {
      text-color: @fg;
      placeholder: "Type to search";
      placeholder-color: @fg-muted;
    }

    listview {
      background-color: transparent;
      padding: 2px;
      columns: 1;
      lines: 8;
      spacing: 8px;
      scrollbar: false;
      dynamic: true;
    }

    element {
      padding: 10px;
      border-radius: 12px;
      background-color: @bg-alt;
      text-color: @fg;
    }

    element alternate {
      background-color: @bg-alt-2;
    }

    element selected {
      background-color: @accent;
      text-color: #1b1024;
    }

    element-icon {
      size: 24px;
      margin: 0px 10px 0px 0px;
    }

    mode-switcher {
      spacing: 8px;
    }

    button {
      padding: 6px 10px;
      border-radius: 999px;
      background-color: @bg-alt;
      text-color: @fg-muted;
    }

    button selected {
      background-color: @accent;
      text-color: #1b1024;
    }

    message {
      margin: 4px 0px 0px 0px;
      background-color: transparent;
    }

    textbox {
      text-color: @fg-muted;
    }
  '';
}
