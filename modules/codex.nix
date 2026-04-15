{ lib, pkgs, ... }:

let
  codexSettings = {
    model = "gpt-5.4";
    model_reasoning_effort = "xhigh";

    mcp_servers = {
      svelte = {
        url = "https://mcp.svelte.dev/mcp";
        enabled = true;
      };
      better_auth = {
        url = "https://mcp.chonkie.ai/better-auth/better-auth-builder/mcp";
        enabled = true;
      };
      stripe = {
        url = "https://mcp.stripe.com";
        enabled = true;
      };
    };
  };

  codexConfigTemplate = (pkgs.formats.toml { }).generate "codex-config" codexSettings;
in
{
  programs.codex = {
    enable = true;

    context = ''
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

  # Codex persists slash-command changes like /permissions and /model back
  # into config.toml. Seed a writable config instead of managing that file
  # as an immutable store symlink.
  home.activation.codexWritableConfig = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    codex_dir="$HOME/.codex"
    codex_config="$codex_dir/config.toml"

    mkdir -p "$codex_dir"

    if [ ! -e "$codex_config" ]; then
      install -m 600 ${codexConfigTemplate} "$codex_config"
    elif [ -L "$codex_config" ]; then
      target="$(readlink -f "$codex_config")"
      case "$target" in
        /nix/store/*-codex-config)
          rm "$codex_config"
          install -m 600 ${codexConfigTemplate} "$codex_config"
          ;;
      esac
    fi
  '';
}
