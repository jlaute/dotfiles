" Plugins
call plug#begin("$XDG_CONFIG_HOME/nvim/plugged")
    Plug 'chrisbra/csv.vim'
    Plug 'moll/vim-bbye'
    Plug 'simeji/winresizer'
    Plug 'simnalamburt/vim-mundo'
call plug#end()

set clipboard+=unnamedplus
set noswapfile

set undofile
set undodir=$HOME/.config/nvim/undo
set undolevels=10000
set undoreload=10000

set number

set autoindent
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

nnoremap <space> <nop>
let mapleader = "\<space>"

nnoremap <leader>bn :bn<cr> ;buffer next
nnoremap <leader>tn gt ;new tab
nnoremap <leader>w :w<cr>

" Config for chrisbra/csv.vim
augroup filetype_csv
    autocmd! 

    autocmd BufRead,BufWritePost *.csv :%ArrangeColumn!
    autocmd BufWritePre *.csv :%UnArrangeColumn
augroup END
