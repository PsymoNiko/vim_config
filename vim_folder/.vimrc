"==============================
" Basic Config
"==============================
set nocompatible
filetype off

set encoding=utf-8
set number
" set relativenumber
set showcmd
set cursorline
set wildmenu
set hidden
set backspace=indent,eol,start
syntax on
set t_Co=256

"==============================
" Vundle Setup
"==============================
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Vundle itself
Plugin 'VundleVim/Vundle.vim'

" === Git Plugins ===
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'
Plugin 'mhinz/vim-signify'
Plugin 'jreybert/vimagit'

" === Python Dev ===
Plugin 'davidhalter/jedi-vim'
Plugin 'vim-syntastic/syntastic'
Plugin 'dense-analysis/ale'
Plugin 'nvie/vim-flake8'
Plugin 'vim-python/python-syntax'
Plugin 'google/yapf'
Plugin 'tmhedberg/SimpylFold'
Plugin 'vim-scripts/indentpython.vim'

" === Autocompletion (alternative to YouCompleteMe) ===
" YouCompleteMe is heavy; if you're okay using coc.nvim:
" Plugin 'neoclide/coc.nvim', {'branch': 'release'}

Plugin 'ycm-core/YouCompleteMe', { 'do': './install.py' }

" === UI Enhancements ===
Plugin 'preservim/nerdtree'
Plugin 'vim-airline/vim-airline'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'kien/ctrlp.vim'
Plugin 'jnurmine/Zenburn'
Plugin 'altercation/vim-colors-solarized'
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'

call vundle#end()
filetype plugin indent on

"==============================
" Python Specific Settings
"==============================
autocmd FileType python setlocal tabstop=4 softtabstop=4 shiftwidth=4 textwidth=88 expandtab autoindent fileformat=unix
let g:ale_linters = {'python': ['flake8']}
let g:ale_fixers = {'python': ['yapf']}
let g:ale_python_flake8_executable = 'flake8'
let g:ale_fix_on_save = 1

let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_auto_trigger = 1
let g:ycm_semantic_triggers = {'python': ['.']}

let g:SimpylFold_docstring_preview = 1
let python_highlight_all = 1
let NERDTreeIgnore = ['\.pyc$', '\~$']

autocmd BufWritePre *.py silent! execute 'YapfFormat'

" Optional: Highlight trailing whitespace
highlight BadWhitespace ctermbg=red guibg=red
autocmd BufRead,BufNewFile *.py,*.pyw match BadWhitespace /\s\+$/

"==============================
" JavaScript / HTML / CSS Indent
"==============================
autocmd FileType javascript,html,css setlocal tabstop=2 softtabstop=2 shiftwidth=2

"==============================
" Git Mappings
"==============================
let mapleader = "\<Space>"

" Fugitive
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gc :Gcommit<CR>
nnoremap <leader>gp :Gpush<CR>
nnoremap <leader>gl :Glog<CR>
nnoremap <leader>gb :Gblame<CR>

" GitGutter
nnoremap <leader>hp :GitGutterPreviewHunk<CR>
nnoremap <leader>hs :GitGutterStageHunk<CR>
nnoremap <leader>hu :GitGutterUndoHunk<CR>

" Signify
nnoremap ]c :SignifyNextHunk<CR>
nnoremap [c :SignifyPrevHunk<CR>

" Magit style
nnoremap <leader>gm :Magit<CR>

" Git commit spell checking
autocmd FileType gitcommit setlocal spell textwidth=72

"==============================
" UI Shortcuts
"==============================
nnoremap <space> za
nnoremap <leader>n :NERDTreeToggle<CR>
" nnoremap <F5> :call togglebg#map("<F5>")<CR>

"==============================
" Colorscheme
"==============================
" Choose your favorite:
" colorscheme solarized
" colorscheme zenburn
set background=dark


