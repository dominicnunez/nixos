# modules/home-manager/neovim.nix - Neovim configuration for Home Manager
{ config, pkgs, lib, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    
    # Neovim plugins
    plugins = with pkgs.vimPlugins; [
      # Themes
      dracula-vim
      gruvbox
      onedark-nvim
      tokyonight-nvim
      
      # File tree
      nvim-tree-lua
      nvim-web-devicons
      
      # Telescope (fuzzy finder)
      telescope-nvim
      plenary-nvim
      
      # Treesitter
      nvim-treesitter.withAllGrammars
      nvim-treesitter-textobjects
      nvim-treesitter-context
      
      # LSP
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      luasnip
      cmp_luasnip
      friendly-snippets
      lspkind-nvim
      
      # UI improvements
      lualine-nvim
      bufferline-nvim
      indent-blankline-nvim
      nvim-colorizer-lua
      
      # Git integration
      gitsigns-nvim
      vim-fugitive
      
      # Utilities
      nvim-autopairs
      comment-nvim
      which-key-nvim
      toggleterm-nvim
      
      # Markdown
      markdown-preview-nvim
      
      # Surround
      nvim-surround
      
      # Better motions
      leap-nvim
      
      # Debug
      nvim-dap
      nvim-dap-ui
    ];
    
    # Main configuration
    extraConfig = ''
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
      
      " Better window navigation
      nnoremap <C-h> <C-w>h
      nnoremap <C-j> <C-w>j
      nnoremap <C-k> <C-w>k
      nnoremap <C-l> <C-w>l
      
      " Buffer navigation
      nnoremap <S-l> :bnext<CR>
      nnoremap <S-h> :bprevious<CR>
      
      " Move text up and down
      vnoremap J :m '>+1<CR>gv=gv
      vnoremap K :m '<-2<CR>gv=gv
      
      " Stay in indent mode
      vnoremap < <gv
      vnoremap > >gv
      
      " Keep cursor centered
      nnoremap n nzzzv
      nnoremap N Nzzzv
      nnoremap J mzJ`z
      
      " Replace without yanking
      vnoremap p "_dP
    '';
    
    # Lua configuration
    extraLuaConfig = ''
      -- Disable netrw for nvim-tree
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
      
      -- Setup nvim-tree
      require("nvim-tree").setup({
        view = {
          width = 30,
        },
        renderer = {
          group_empty = true,
        },
        filters = {
          dotfiles = false,
        },
      })
      
      -- Setup Telescope
      require('telescope').setup{
        defaults = {
          file_ignore_patterns = {"node_modules", ".git/"},
        }
      }
      
      -- Setup Treesitter
      require'nvim-treesitter.configs'.setup {
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = true
        },
      }
      
      -- Setup LSP
      local lspconfig = require('lspconfig')
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      
      -- Setup completion
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
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
          { name = 'path' },
        })
      })
      
      -- Setup lualine
      require('lualine').setup {
        options = {
          theme = 'dracula'
        }
      }
      
      -- Setup gitsigns
      require('gitsigns').setup()
      
      -- Setup Comment
      require('Comment').setup()
      
      -- Setup autopairs
      require('nvim-autopairs').setup{}
      
      -- Setup which-key
      require("which-key").setup{}
      
      -- Setup bufferline
      require("bufferline").setup{}
      
      -- Setup indent-blankline
      require("ibl").setup()
      
      -- Setup colorizer
      require'colorizer'.setup()
      
      -- Setup surround
      require("nvim-surround").setup()
      
      -- Setup leap
      require('leap').create_default_mappings()
      
      -- Setup toggleterm
      require("toggleterm").setup{
        open_mapping = [[<c-\>]],
        direction = 'float',
        float_opts = {
          border = 'curved',
        },
      }
    '';
    
    # Extra packages needed for LSP and functionality
    extraPackages = with pkgs; [
      # Language servers
      # nodePackages.typescript-language-server  # Install via npm to avoid collision with gemini-cli
      nodePackages.vscode-langservers-extracted
      lua-language-server
      nil # Nix LSP
      rust-analyzer
      gopls
      pyright
      
      # Formatters
      nixpkgs-fmt
      rustfmt
      black
      prettierd
      
      # Tools
      ripgrep
      fd
    ];
  };
}