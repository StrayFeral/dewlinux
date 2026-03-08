set nocompatible

" ===============================================
" EVG SETTINGS
" ===============================================

set backspace=indent,eol,start
set history=50
set ruler
set showcmd
set autoindent
set shiftwidth=4
set tabstop=4
set expandtab
set nu
set nobackup

if has("mouse")
    set mouse=a
endif

set hlsearch
set ignorecase
set incsearch

" Enable filetype and syntax (Must be before plugin configs)
filetype plugin indent on
syntax on

" Spellcheck config
nmap 1 :set spell spelllang=en<cr>
nmap 2 :set spell spelllang=bg<cr>
nmap 3 :set spell spelllang=ru<cr>
nmap 4 :set spell spelllang=fr<cr>
nmap 0 :set nospell<cr>

