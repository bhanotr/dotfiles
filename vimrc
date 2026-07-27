vim9script

# --- VIM 9 BUILD-IN DEFAULTS (9.2 OPTIMIZATIONS) ---
set completeopt+=fuzzy,nosort

# --- SYSTEM CLIPBOARD INTEGRATION ---
# Links Vim's default yank/delete operations directly to your system clipboard
set clipboard=unnamedplus

# --- SECURITY PRECAUTIONS (FIXED) ---
# Safely disables expression evaluations inside modelines to prevent exploits
set nomodelineexpr
set modelines=5

# --- MODERN USER INTERFACE ---
syntax on
set number
#set cursorline
set termguicolors            

# --- ADVANCED INDENTATION ---
set autoindent
set smartindent
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

# --- COMFORTABLE SEARCHING ---
set hlsearch
set incsearch
set ignorecase
set smartcase

# --- QUALITY OF LIFE ---
set mouse=a                  
set wildmenu                 
set hidden                   
set nobackup                 
set noswapfile               

# --- VIM9 SCRIPT FUNCTION EXAMPLE ---
def ToggleLineNumbers()
    if &number
        set nonumber
    else
        set number
    endif
enddef

nnoremap <F3> :call ToggleLineNumbers()<CR>

