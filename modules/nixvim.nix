{ inputs, ... }:

{
  imports = [ inputs.nixvim.homeModules.nixvim ];

  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    imports = [
      (
        { config, pkgs, ... }:
        {
          globals.mapleader = " ";
          globals.maplocalleader = " ";

          opts = {
            number = true;
            relativenumber = true;
            termguicolors = true;
            cursorline = true;
            signcolumn = "yes";
            scrolloff = 8;
            splitbelow = true;
            splitright = true;
            ignorecase = true;
            smartcase = true;
            undofile = true;
            updatetime = 250;
            timeoutlen = 400;
            expandtab = true;
            shiftwidth = 2;
            tabstop = 2;
            smartindent = true;
            wrap = false;
            clipboard = "unnamedplus";
            mouse = "a";
            completeopt = "menu,menuone,noselect";
            laststatus = 3;
            statusline = "%f %h%m%r%=%{&filetype}  %l:%c  %p%% ";
          };

          clipboard.providers.wl-copy.enable = true;
          colorschemes.catppuccin = {
            enable = true;
            settings.flavour = "mocha";
          };

          # Use Neovim's native LSP API; lspconfig supplies server defaults.
          plugins.lspconfig.enable = true;
          lsp.servers = {
            "*".config.capabilities.__raw = "require('blink.cmp').get_lsp_capabilities()";
            nixd.enable = true;
            gopls.enable = true;
            ts_ls.enable = true;
            svelte.enable = true;
            html.enable = true;
            cssls.enable = true;
            jsonls.enable = true;
            bashls.enable = true;
          };

          plugins.blink-cmp = {
            enable = true;
            setupLspCapabilities = false;
            settings = {
              keymap.preset = "default";
              completion.documentation.auto_show = true;
              signature.enabled = true;
            };
          };

          plugins.mini-pick.enable = true;
          extraPackages = with pkgs; [ ripgrep ];

          plugins.treesitter = {
            enable = true;
            highlight.enable = true;
            grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
              bash
              css
              go
              gomod
              gosum
              html
              javascript
              json
              lua
              markdown
              markdown_inline
              nix
              regex
              svelte
              toml
              tsx
              typescript
              vim
              vimdoc
              yaml
            ];
          };

          plugins.conform-nvim = {
            enable = true;
            autoInstall.enable = true;
            settings = {
              formatters_by_ft = {
                nix = [ "nixfmt" ];
                go = [
                  "goimports"
                  "gofmt"
                ];
                javascript = [ "prettier" ];
                javascriptreact = [ "prettier" ];
                typescript = [ "prettier" ];
                typescriptreact = [ "prettier" ];
                json = [ "prettier" ];
                html = [ "prettier" ];
                css = [ "prettier" ];
                markdown = [ "prettier" ];
                yaml = [ "prettier" ];
                # The Svelte LSP formats with the project's Svelte plugin.
                svelte = [ ];
              };
              format_on_save = {
                timeout_ms = 2000;
                lsp_format = "fallback";
              };
            };
          };

          keymaps =
            map
              (
                {
                  key,
                  action,
                  desc,
                }:
                {
                  mode = "n";
                  inherit key action;
                  options = {
                    silent = true;
                    inherit desc;
                  };
                }
              )
              [
                {
                  key = "<leader>ff";
                  action = "<cmd>Pick files<cr>";
                  desc = "Find files";
                }
                {
                  key = "<leader>fg";
                  action = "<cmd>Pick grep_live<cr>";
                  desc = "Search project";
                }
                {
                  key = "<leader>fb";
                  action = "<cmd>Pick buffers<cr>";
                  desc = "Find buffers";
                }
                {
                  key = "<leader>fh";
                  action = "<cmd>Pick help<cr>";
                  desc = "Search help";
                }
                {
                  key = "<leader>e";
                  action = "<cmd>Explore<cr>";
                  desc = "Browse directory";
                }
                {
                  key = "<leader>w";
                  action = "<cmd>write<cr>";
                  desc = "Save file";
                }
                {
                  key = "<leader>f";
                  action = "<cmd>lua require('conform').format({ async = true, lsp_format = 'fallback' })<cr>";
                  desc = "Format buffer";
                }
                {
                  key = "<leader>d";
                  action = "<cmd>lua vim.diagnostic.open_float()<cr>";
                  desc = "Show diagnostic";
                }
                {
                  key = "<leader>q";
                  action = "<cmd>lua vim.diagnostic.setqflist()<cr>";
                  desc = "Project diagnostics";
                }
                {
                  key = "<Esc>";
                  action = "<cmd>nohlsearch<cr>";
                  desc = "Clear search highlight";
                }
                {
                  key = "<C-h>";
                  action = "<C-w>h";
                  desc = "Focus left split";
                }
                {
                  key = "<C-j>";
                  action = "<C-w>j";
                  desc = "Focus lower split";
                }
                {
                  key = "<C-k>";
                  action = "<C-w>k";
                  desc = "Focus upper split";
                }
                {
                  key = "<C-l>";
                  action = "<C-w>l";
                  desc = "Focus right split";
                }
                {
                  key = "<C-d>";
                  action = "<C-d>zz";
                  desc = "Scroll down and center";
                }
                {
                  key = "<C-u>";
                  action = "<C-u>zz";
                  desc = "Scroll up and center";
                }
              ];

          extraConfigLua = ''
            vim.diagnostic.config({
              severity_sort = true,
              underline = true,
              virtual_text = { spacing = 2, source = "if_many" },
              float = { border = "rounded", source = true },
            })
            vim.api.nvim_create_autocmd("LspAttach", {
              callback = function(event)
                vim.keymap.set("n", "gd", vim.lsp.buf.definition,
                  { buffer = event.buf, desc = "Go to definition" })
              end,
            })
          '';
        }
      )
    ];
  };
}
