vim9script

set undofile
set undodir=~/.vim/undo
if !isdirectory($HOME .. "/.vim/undo")
    mkdir($HOME .. "/.vim/undo", "p")
endif

set clipboard=unnamedplus

set completeopt=menuone,noinsert,noselect

set ignorecase
set smartcase

set number
set relativenumber

set scrolloff=5
set wildoptions=pum
set splitright

set breakindent
#set list
set signcolumn=yes
set termguicolors
set autoread
set background=dark
colorscheme elflord
set mouse=a

filetype plugin indent on

# Keep cursor centered when jumping
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

# Visual mode indent/dedent without losing selection
vnoremap < <gv
vnoremap > >gv

packadd matchit
runtime ftplugin/man.vim
packadd termdebug
packadd comment

set path+=**
set wildignore+=**/node_modules/**,**/.git/**,**/build/**,**/target/**,**/__pycache__/**,*.o,*.pyc

set grepprg=rg\ --vimgrep\ --smart-case
set grepformat=%f:%l:%c:%m

packadd lsp

call LspOptionsSet({
    autoComplete: false,
})

# Clangd language server
call LspAddServer([{
    name: 'clangd',
    filetype: ['c', 'cpp'],
    path: '/usr/bin/clangd',
    args: ['--background-index', '--query-driver=/home/ritwik/osi/xpack-riscv-none-elf-gcc-14.2.0-3/**/riscv*'],
}])

# def LspGd()
#     if winnr('$') == 1
#         vertical LspGotoDefinition
#     else
#         LspGotoDefinition
#     endif
# enddef

# nnoremap gd <ScriptCmd>call LspGd()<CR>
nnoremap gd <Cmd>LspGotoDefinition<CR>
nnoremap gr <Cmd>LspShowReferences<CR>
nnoremap gD <Cmd>LspGotoDeclaration<CR>
nnoremap gi <Cmd>LspGotoImpl<CR>
nnoremap K <Cmd>LspHover<CR>
nnoremap <leader>rn <Cmd>LspRename<CR>
nnoremap <leader>ca <Cmd>LspCodeAction<CR>
nnoremap [d <Cmd>LspDiag prev<CR>
nnoremap ]d <Cmd>LspDiag next<CR>
nnoremap <leader>dl <Cmd>LspDiag show<CR>
inoremap <C-n> <C-x><C-o>
autocmd FileType c,cpp setlocal omnifunc=LspOmniFunc
