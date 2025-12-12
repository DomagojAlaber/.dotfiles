{ config, lib, pkgs, ... }:

let
  cfg = config.programs.codex;
  toml = pkgs.formats.toml { };

  baseSettings =
    {
      model = "gpt-5.1-codex-max";
      model_reasoning_effort = "xhigh";

      mcp_servers.svelte = {
        command = "npx";
        args = [
          "-y"
          "@sveltejs/mcp"
        ];
      };

      projects = {
        "/home/domagoj/.dotfiles".trust_level = "trusted";
        "/home/domagoj/git/loxlio".trust_level = "trusted";
        "/home/domagoj/git/nixpkgs".trust_level = "trusted";
        "/home/domagoj/git/xxl".trust_level = "trusted";
        "/home/domagoj/git/istrianguide".trust_level = "trusted";
        "/home/domagoj/Downloads/themeforest-3eHmlYIp-triply-tour-booking-wordpress-theme/triply-full/triply-theme/triply".trust_level =
          "untrusted";
      };

      notice = {
        hide_gpt5_1_migration_prompt = true;
        "hide_gpt-5.1-codex-max_migration_prompt" = true;
      };
    }
    // lib.optionalAttrs (cfg.custom-instructions != "") {
      custom_instructions = cfg.custom-instructions;
    };

  finalSettings = lib.recursiveUpdate baseSettings cfg.settings;
in
{
  options.programs.codex = {
    enable = lib.mkEnableOption "Codex CLI configuration";

    custom-instructions = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Custom system instructions passed through Codex (written to config.toml).";
    };

    settings = lib.mkOption {
      type = toml.type;
      default = { };
      description = "Additional config.toml settings merged on top of the defaults.";
    };
  };

  config = lib.mkMerge [
    {
      programs.codex = {
        enable = true;
        custom-instructions = lib.mkDefault ''
          You are able to use the Svelte MCP server, where you have access to comprehensive Svelte 5 and SvelteKit documentation. Here's how to use the available tools effectively:

          ## Available MCP Tools:

          ### 1. list-sections

          Use this FIRST to discover all available documentation sections. Returns a structured list with titles, use_cases, and paths.
          When asked about Svelte or SvelteKit topics, ALWAYS use this tool at the start of the chat to find relevant sections.

          ### 2. get-documentation

          Retrieves full documentation content for specific sections. Accepts single or multiple sections.
          After calling the list-sections tool, you MUST analyze the returned documentation sections (especially the use_cases field) and then use the get-documentation tool to fetch ALL documentation sections that are relevant for the user's task.

          ### 3. svelte-autofixer

          Analyzes Svelte code and returns issues and suggestions.
          You MUST use this tool whenever writing Svelte code before sending it to the user. Keep calling it until no issues or suggestions are returned.

          ### 4. playground-link

          Generates a Svelte Playground link with the provided code.
          After completing the code, ask the user if they want a playground link. Only call this tool after user confirmation and NEVER if code was written to files in their project.
        '';
      };
    }

    (lib.mkIf cfg.enable {
      home.packages = [ pkgs.codex ];

      home.file.".codex/config.toml".source = toml.generate "codex-config.toml" finalSettings;
    })
  ];
}
