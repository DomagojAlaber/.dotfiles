{ config, pkgs, ... }:

let
  inherit (config.lib.formats.rasi) mkLiteral;
in
{
  programs.rofi = {
    enable = true;

    theme = {
      "*" = {
        rosewater = mkLiteral "#f5e0dc";
        flamingo = mkLiteral "#f2cdcd";
        pink = mkLiteral "#f5c2e7";
        mauve = mkLiteral "#cba6f7";
        red = mkLiteral "#f38ba8";
        maroon = mkLiteral "#eba0ac";
        peach = mkLiteral "#fab387";
        yellow = mkLiteral "#f9e2af";
        green = mkLiteral "#a6e3a1";
        teal = mkLiteral "#94e2d5";
        sky = mkLiteral "#89dceb";
        sapphire = mkLiteral "#74c7ec";
        blue = mkLiteral "#89b4fa";
        lavender = mkLiteral "#b4befe";
        text = mkLiteral "#cdd6f4";
        subtext1 = mkLiteral "#bac2de";
        subtext0 = mkLiteral "#a6adc8";
        overlay2 = mkLiteral "#9399b2";
        overlay1 = mkLiteral "#7f849c";
        overlay0 = mkLiteral "#6c7086";
        surface2 = mkLiteral "#585b70";
        surface1 = mkLiteral "#45475a";
        surface0 = mkLiteral "#313244";
        base = mkLiteral "#1e1e2e";
        mantle = mkLiteral "#181825";
        crust = mkLiteral "#11111b";

        "selected-active-foreground" = mkLiteral "@background";
        lightfg = mkLiteral "@text";
        separatorcolor = mkLiteral "@foreground";
        "urgent-foreground" = mkLiteral "@red";
        "alternate-urgent-background" = mkLiteral "@lightbg";
        lightbg = mkLiteral "@mantle";

        "background-color" = mkLiteral "transparent";
        "border-color" = mkLiteral "@foreground";
        "normal-background" = mkLiteral "@background";
        "selected-urgent-background" = mkLiteral "@red";
        "alternate-active-background" = mkLiteral "@lightbg";
        spacing = 2;
        "alternate-normal-foreground" = mkLiteral "@foreground";
        "urgent-background" = mkLiteral "@background";
        "selected-normal-foreground" = mkLiteral "@lightbg";
        "active-foreground" = mkLiteral "@blue";

        background = mkLiteral "@base";
        foreground = mkLiteral "@text";

        "selected-active-background" = mkLiteral "@blue";
        "active-background" = mkLiteral "@background";
        "selected-normal-background" = mkLiteral "@lightfg";
        "alternate-normal-background" = mkLiteral "@lightbg";
        "selected-urgent-foreground" = mkLiteral "@background";
        "normal-foreground" = mkLiteral "@foreground";
        "alternate-urgent-foreground" = mkLiteral "@red";
        "alternate-active-foreground" = mkLiteral "@blue";
      };

      element = {
        padding = mkLiteral "1px";
        cursor = mkLiteral "pointer";
        spacing = mkLiteral "5px";
        border = 0;
      };

      "element normal.normal" = {
        "background-color" = mkLiteral "@normal-background";
        "text-color" = mkLiteral "@normal-foreground";
      };
      "element normal.urgent" = {
        "background-color" = mkLiteral "@urgent-background";
        "text-color" = mkLiteral "@urgent-foreground";
      };
      "element normal.active" = {
        "background-color" = mkLiteral "@active-background";
        "text-color" = mkLiteral "@active-foreground";
      };

      "element selected.normal" = {
        "background-color" = mkLiteral "@selected-normal-background";
        "text-color" = mkLiteral "@selected-normal-foreground";
      };
      "element selected.urgent" = {
        "background-color" = mkLiteral "@selected-urgent-background";
        "text-color" = mkLiteral "@selected-urgent-foreground";
      };
      "element selected.active" = {
        "background-color" = mkLiteral "@selected-active-background";
        "text-color" = mkLiteral "@selected-active-foreground";
      };

      "element alternate.normal" = {
        "background-color" = mkLiteral "@alternate-normal-background";
        "text-color" = mkLiteral "@alternate-normal-foreground";
      };
      "element alternate.urgent" = {
        "background-color" = mkLiteral "@alternate-urgent-background";
        "text-color" = mkLiteral "@alternate-urgent-foreground";
      };
      "element alternate.active" = {
        "background-color" = mkLiteral "@alternate-active-background";
        "text-color" = mkLiteral "@alternate-active-foreground";
      };

      "element-text" = {
        "background-color" = mkLiteral "transparent";
        cursor = mkLiteral "inherit";
        highlight = mkLiteral "inherit";
        "text-color" = mkLiteral "inherit";
      };

      "element-icon" = {
        "background-color" = mkLiteral "transparent";
        size = mkLiteral "1.0000em";
        cursor = mkLiteral "inherit";
        "text-color" = mkLiteral "inherit";
      };

      window = {
        padding = 5;
        "background-color" = mkLiteral "@background";
        border = 1;
      };

      mainbox = {
        padding = 0;
        border = 0;
      };

      message = {
        padding = mkLiteral "1px";
        "border-color" = mkLiteral "@separatorcolor";
        border = mkLiteral "2px dash 0px 0px";
      };

      textbox = {
        "text-color" = mkLiteral "@foreground";
      };

      listview = {
        padding = mkLiteral "2px 0px 0px";
        scrollbar = true;
        "border-color" = mkLiteral "@separatorcolor";
        spacing = mkLiteral "2px";
        "fixed-height" = 0;
        border = mkLiteral "2px dash 0px 0px";
      };

      scrollbar = {
        width = mkLiteral "4px";
        padding = 0;
        "handle-width" = mkLiteral "8px";
        border = 0;
        "handle-color" = mkLiteral "@normal-foreground";
      };

      sidebar = {
        "border-color" = mkLiteral "@separatorcolor";
        border = mkLiteral "2px dash 0px 0px";
      };

      button = {
        cursor = mkLiteral "pointer";
        spacing = 0;
        "text-color" = mkLiteral "@normal-foreground";
      };

      "button selected" = {
        "background-color" = mkLiteral "@selected-normal-background";
        "text-color" = mkLiteral "@selected-normal-foreground";
      };

      "num-filtered-rows" = {
        expand = false;
        "text-color" = mkLiteral "Gray";
      };
      "num-rows" = {
        expand = false;
        "text-color" = mkLiteral "Gray";
      };

      "textbox-num-sep" = {
        expand = false;
        str = "/";
        "text-color" = mkLiteral "Gray";
      };

      inputbar = {
        padding = mkLiteral "1px";
        spacing = mkLiteral "0px";
        "text-color" = mkLiteral "@normal-foreground";
        children = map mkLiteral [
          "prompt"
          "textbox-prompt-colon"
          "entry"
          "num-filtered-rows"
          "textbox-num-sep"
          "num-rows"
          "case-indicator"
        ];
      };

      "case-indicator" = {
        spacing = 0;
        "text-color" = mkLiteral "@normal-foreground";
      };

      entry = {
        "text-color" = mkLiteral "@normal-foreground";
        cursor = mkLiteral "text";
        spacing = 0;
        "placeholder-color" = mkLiteral "Gray";
        placeholder = "Type to filter";
      };

      prompt = {
        spacing = 0;
        "text-color" = mkLiteral "@normal-foreground";
      };

      "textbox-prompt-colon" = {
        margin = mkLiteral "0px 0.3000em 0.0000em 0.0000em";
        expand = false;
        str = ":";
        "text-color" = mkLiteral "inherit";
      };
    };
  };
}
