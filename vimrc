set nocompatible              " be iMproved, required
filetype off                  " required

" Set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" Alternatively, pass a path where Vundle should install plugins
" call vundle#begin('~/some/path/here')

" Let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Git-related plugins
Plugin 'tpope/vim-fugitive'             " Git wrapper for Vim
Plugin 'airblade/vim-gitgutter'         " Shows Git diff in the sign column
Plugin 'mhinz/vim-signify'              " Shows Git changes in the gutter
Plugin 'jreybert/vimagit'               " Magit-inspired Git interface for Vim

" Other plugins
Plugin 'tmhedberg/SimpylFold'
" Bundle 'Valloric/YouCompleteMe'
Plugin 'vim-syntastic/syntastic'
Plugin 'vim-scripts/indentpython.vim'
Plugin 'dense-analysis/ale'
Plugin 'nvie/vim-flake8'
Plugin 'ycm-core/YouCompleteMe', { 'do': './install.py' }
Plugin 'vim-python/python-syntax'
Plugin 'google/yapf'
Plugin 'preservim/nerdtree'
Plugin 'vim-airline/vim-airline'
Plugin 'jnurmine/Zenburn'
Plugin 'altercation/vim-colors-solarized'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'kien/ctrlp.vim'
Plugin 'Shougo/vimshell.vim'
"Plugin 'tpope/tcomment'
"Plugin 'tpope/tcomment.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
" filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

syntax on

set t_Co=256

" colorscheme atom-dark-256

set foldmethod=indent
set foldlevel=99

nnoremap <space> za

" Python-specific settings
au BufNewFile, BufRead *.py
    \ set tabstop=4
    \ set softtabstop=4
    \ set shiftwidth=4
    \ set textwidth=4
    \ set expandtab
    \ set autoindent
    \ set fileformat=unix


au BufNewFile,BufRead *.js, *.html, *.css
    \ set tabstop=2
    \ set softtabstop=2
    \ set shiftwidth=2

let g:ale_linters = {'python': ['flake8']}

let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_auto_trigger = 1
let g:ycm_semantic_triggers =  {'python': ['.']}

autocmd BufWritePre *.py silent! execute 'YapfFormat'

set number

" =========================
" Git-Related Customizations
" =========================

" Leader key
let mapleader = "\<Space>"

" Fugitive mappings
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gc :Gcommit<CR>
nnoremap <leader>gp :Gpush<CR>
nnoremap <leader>gl :Glog<CR>
nnoremap <leader>gb :Gblame<CR>

" GitGutter mappings
nnoremap <leader>hp :GitGutterPreviewHunk<CR>
nnoremap <leader>hs :GitGutterStageHunk<CR>
nnoremap <leader>hu :GitGutterUndoHunk<CR>

" vim-signify mappings
nnoremap ]c :SignifyNextHunk<CR>
nnoremap [c :SignifyPrevHunk<CR>

" Magit-inspired interface mapping
nnoremap <leader>gm :Magit<CR>

" Set up commit message settings
autocmd FileType gitcommit setlocal spell textwidth=72

" Optional: Toggle NERDTree with <leader>n
nnoremap <leader>n :NERDTreeToggle<CR>

"if has('gui_running')
"  set background=dark
"  colorscheme solarized
"else
"  colorscheme zenburn
"endif
"
"call togglebg#map("<F5>")


let g:SimpylFold_docstring_preview=1
let python_highlight_all=1
syntax on
let NERDTreeIgnore=['\.pyc$', '\~$'] "ignore files in NERDTree

"au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/
set encoding=utf-8
