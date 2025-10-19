set nocompatible          " modern mode
syntax on                 " syntax highlighting
filetype plugin indent on " enable ftplugins & indent
set number                " line numbers
set relativenumber
set mouse=a               " mouse support
set clipboard=unnamedplus " system clipboard
set incsearch hlsearch    " better search experience
set ignorecase smartcase  " smarter case handling
set expandtab shiftwidth=4 tabstop=4 " spaces instead of tabs
set undofile              " persistent undo
colorscheme evening
runtime! ftplugin/man.vim
set rtp+=/usr/share/doc/fzf/examples

nnoremap <C-p> :Files<CR>
nnoremap <C-b> :Buffers<CR>
nnoremap <C-f> :Rg<CR>

packadd lsp

nnoremap gd <cmd>LspGotoDefinition<CR>
nnoremap gr <cmd>LspShowReferences<CR>
nnoremap gR <cmd>LspPeekReferences<CR>
nnoremap K <cmd>LspHover<CR>

call LspAddServer([#{name: 'clangd',
                 \   filetype: ['c', 'cpp'],
                 \   path: '/usr/bin/clangd',
                 \   args: ['--background-index', '--clang-tidy']
                 \ }])

call LspAddServer([#{name: 'jdtls',
                 \   filetype: ['java'],
                 \   path: expand('~/tools/jdtls/bin/jdtls'),
                 \   args: ['-data', getcwd() . '/.jdtls-workspace']
                 \ }])
