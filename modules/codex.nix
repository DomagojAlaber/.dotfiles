{ lib, pkgs, ... }:

let
  codexSettings = {
    model = "gpt-5.5";
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
    skills = {
      frontend-design = ''
        ---
        name: frontend-design
        description: Create distinctive, production-grade frontend interfaces with high design quality. Use this skill when the user asks to build web components, pages, artifacts, posters, or applications (examples include websites, landing pages, dashboards, React components, HTML/CSS layouts, or when styling/beautifying any web UI). Generates creative, polished code and UI design that avoids generic AI aesthetics.
        ---

        This skill guides creation of distinctive, production-grade frontend interfaces that avoid generic "AI slop" aesthetics. Implement real working code with exceptional attention to aesthetic details and creative choices.

        The user provides frontend requirements: a component, page, application, or interface to build. They may include context about the purpose, audience, or technical constraints.

        ## Design Thinking

        Before coding, understand the context and commit to a BOLD aesthetic direction:

        - **Purpose**: What problem does this interface solve? Who uses it?
        - **Tone**: Pick an extreme: brutally minimal, maximalist chaos, retro-futuristic, organic/natural, luxury/refined, playful/toy-like, editorial/magazine, brutalist/raw, art deco/geometric, soft/pastel, industrial/utilitarian, etc. There are so many flavors to choose from. Use these for inspiration but design one that is true to the aesthetic direction.
        - **Constraints**: Technical requirements (framework, performance, accessibility).
        - **Differentiation**: What makes this UNFORGETTABLE? What's the one thing someone will remember?

        **CRITICAL**: Choose a clear conceptual direction and execute it with precision. Bold maximalism and refined minimalism both work - the key is intentionality, not intensity.

        Then implement working code (HTML/CSS/JS, React, Vue, etc.) that is:

        - Production-grade and functional
        - Visually striking and memorable
        - Cohesive with a clear aesthetic point-of-view
        - Meticulously refined in every detail

        ## Frontend Aesthetics Guidelines

        Focus on:

        - **Typography**: Choose fonts that are beautiful, unique, and interesting. Avoid generic fonts like Arial and Inter; opt instead for distinctive choices that elevate the frontend's aesthetics; unexpected, characterful font choices. Pair a distinctive display font with a refined body font.
        - **Color & Theme**: Commit to a cohesive aesthetic. Use CSS variables for consistency. Dominant colors with sharp accents outperform timid, evenly-distributed palettes.
        - **Motion**: Use animations for effects and micro-interactions. Prioritize CSS-only solutions for HTML. Use Motion library for React when available. Focus on high-impact moments: one well-orchestrated page load with staggered reveals (animation-delay) creates more delight than scattered micro-interactions. Use scroll-triggering and hover states that surprise.
        - **Spatial Composition**: Unexpected layouts. Asymmetry. Overlap. Diagonal flow. Grid-breaking elements. Generous negative space OR controlled density.
        - **Backgrounds & Visual Details**: Create atmosphere and depth rather than defaulting to solid colors. Add contextual effects and textures that match the overall aesthetic. Apply creative forms like gradient meshes, noise textures, geometric patterns, layered transparencies, dramatic shadows, decorative borders, custom cursors, and grain overlays.

        NEVER use generic AI-generated aesthetics like overused font families (Inter, Roboto, Arial, system fonts), cliched color schemes (particularly purple gradients on white backgrounds), predictable layouts and component patterns, and cookie-cutter design that lacks context-specific character.

        Interpret creatively and make unexpected choices that feel genuinely designed for the context. No design should be the same. Vary between light and dark themes, different fonts, different aesthetics. NEVER converge on common choices (Space Grotesk, for example) across generations.

        **IMPORTANT**: Match implementation complexity to the aesthetic vision. Maximalist designs need elaborate code with extensive animations and effects. Minimalist or refined designs need restraint, precision, and careful attention to spacing, typography, and subtle details. Elegance comes from executing the vision well.

        Remember: Codex is capable of extraordinary creative work. Don't hold back, show what can truly be created when thinking outside the box and committing fully to a distinctive vision.
      '';
    };
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
