# modules/development/neovim.nix - Neovim configuration with plugins
{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    
    # Configure Neovim
    configure = {
      customRC = ''
        " Basic settings
        set number relativenumber
        set tabstop=2
        set shiftwidth=2
        set expandtab
        set smartindent
        set wrap
        set ignorecase
        set smartcase
        set hlsearch
        set incsearch
        set termguicolors
        set scrolloff=8
        set signcolumn=yes
        set updatetime=50
        set colorcolumn=80
        set clipboard=unnamedplus
        set mouse=a
        
        " Set leader key
        let mapleader = " "
        
        " Color scheme
        colorscheme dracula
        
        " Key mappings
        nnoremap <leader>ff :Telescope find_files<CR>
        nnoremap <leader>fg :Telescope live_grep<CR>
        nnoremap <leader>fb :Telescope buffers<CR>
        nnoremap <leader>fh :Telescope help_tags<CR>
        nnoremap <leader>e :NvimTreeToggle<CR>
        nnoremap <C-n> :NvimTreeToggle<CR>
        
        " jk to exit insert mode
        inoremap jk <ESC>
        inoremap kj <ESC>
        
        " Window navigation
        nnoremap <C-h> <C-w>h
        nnoremap <C-j> <C-w>j
        nnoremap <C-k> <C-w>k
        nnoremap <C-l> <C-w>l
        
        " Buffer navigation
        nnoremap <S-l> :bnext<CR>
        nnoremap <S-h> :bprevious<CR>
        
        " Move lines up and down
        vnoremap J :m '>+1<CR>gv=gv
        vnoremap K :m '<-2<CR>gv=gv
        
        " Keep cursor centered
        nnoremap <C-d> <C-d>zz
        nnoremap <C-u> <C-u>zz
        nnoremap n nzzzv
        nnoremap N Nzzzv
        
        " Quick save and quit
        nnoremap <leader>w :w<CR>
        nnoremap <leader>q :q<CR>
        nnoremap <leader>Q :qa!<CR>
        
        " Format code
        nnoremap <leader>f :lua vim.lsp.buf.format()<CR>
        
        " Git integration
        nnoremap <leader>gs :Git<CR>
        nnoremap <leader>gc :Git commit<CR>
        nnoremap <leader>gp :Git push<CR>
        nnoremap <leader>gl :Git pull<CR>
        
        " Terminal
        nnoremap <leader>t :terminal<CR>
        
        " Auto-completion setup
        set completeopt=menu,menuone,noselect
        
        " LSP Setup (configured below in Lua)
        lua << EOF
        -- Setup nvim-cmp
        local cmp = require'cmp'
        cmp.setup({
          snippet = {
            expand = function(args)
              require('luasnip').lsp_expand(args.body)
            end,
          },
          mapping = cmp.mapping.preset.insert({
            ['<C-b>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.abort(),
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
            ['<Tab>'] = cmp.mapping.select_next_item(),
            ['<S-Tab>'] = cmp.mapping.select_prev_item(),
          }),
          sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
          }, {
            { name = 'buffer' },
          })
        })
        
        -- Setup language servers
        local lspconfig = require('lspconfig')
        
        -- Python
        lspconfig.pyright.setup{}
        
        -- TypeScript/JavaScript
        lspconfig.tsserver.setup{}
        
        -- Go
        lspconfig.gopls.setup{}
        
        -- Rust
        lspconfig.rust_analyzer.setup{}
        
        -- Java
        lspconfig.jdtls.setup{}
        
        -- C/C++
        lspconfig.clangd.setup{}
        
        -- Lua
        lspconfig.lua_ls.setup{
          settings = {
            Lua = {
              diagnostics = {
                globals = {'vim'}
              }
            }
          }
        }
        
        -- Setup nvim-tree
        require("nvim-tree").setup({
          view = {
            width = 30,
            side = "left",
          },
          renderer = {
            group_empty = true,
          },
          filters = {
            dotfiles = false,
          },
        })
        
        -- Setup treesitter
        require'nvim-treesitter.configs'.setup {
          highlight = {
            enable = true,
          },
          indent = {
            enable = true,
          },
        }
        
        -- Setup telescope
        require('telescope').setup{
          defaults = {
            file_ignore_patterns = {"node_modules", ".git/"},
          }
        }
        
        -- Setup lualine
        require('lualine').setup {
          options = {
            theme = 'dracula',
            icons_enabled = true,
          }
        }
        
        -- Setup gitsigns
        require('gitsigns').setup()
        
        -- Setup indent-blankline
        require("ibl").setup()
        
        -- Setup comment
        require('Comment').setup()
        
        -- Setup autopairs
        require('nvim-autopairs').setup{}
        EOF
      '';
      
      packages.all = with pkgs.vimPlugins; [
        # Essential plugins
        nvim-treesitter.withAllGrammars  # Syntax highlighting
        nvim-lspconfig                    # LSP configuration
        nvim-cmp                          # Completion
        cmp-nvim-lsp                      # LSP completion source
        cmp-buffer                        # Buffer completion source
        luasnip                           # Snippet engine
        
        # File navigation
        telescope-nvim                    # Fuzzy finder
        nvim-tree-lua                     # File explorer
        
        # Git integration
        vim-fugitive                      # Git commands
        gitsigns-nvim                     # Git signs in gutter
        
        # UI enhancements
        lualine-nvim                      # Status line
        indent-blankline-nvim             # Indentation guides
        nvim-web-devicons                 # File icons
        
        # Editing enhancements
        comment-nvim                      # Easy commenting
        nvim-autopairs                    # Auto close brackets
        vim-surround                      # Surround text objects
        
        # Color schemes
        dracula-nvim                      # Dracula theme
        catppuccin-nvim                   # Catppuccin theme
        tokyonight-nvim                   # Tokyo Night theme
        gruvbox-nvim                      # Gruvbox theme
        
        # Language specific
        vim-go                            # Go support
        vim-python-pep8-indent            # Python indentation
        typescript-vim                    # TypeScript syntax
        vim-jsx-pretty                    # JSX syntax
        
        # Misc
        vim-tmux-navigator                # Navigate between vim and tmux
        vim-multiple-cursors              # Multiple cursors
        nerdcommenter                     # Better commenting
        vim-gitgutter                     # Git diff in gutter
      ];
    };
  };
  
  # Additional Neovim tools
  environment.systemPackages = with pkgs; [
    # Language servers (for Neovim LSP)
    nodePackages.pyright              # Python
    nodePackages.typescript-language-server  # TypeScript/JavaScript
    gopls                             # Go
    rust-analyzer                     # Rust
    jdt-language-server               # Java
    clang-tools                       # C/C++
    lua-language-server               # Lua
    nodePackages.vscode-langservers-extracted  # HTML/CSS/JSON
    yaml-language-server              # YAML
    dockerfile-language-server-nodejs # Dockerfile
    
    # Formatters
    black                             # Python formatter
    prettier                          # JS/TS/CSS formatter
    rustfmt                          # Rust formatter
    gofumpt                          # Go formatter
    stylua                           # Lua formatter
    
    # Additional tools
    tree-sitter                      # Parser generator
    ripgrep                          # For telescope grep
    fd                               # For telescope file finding
  ];
}