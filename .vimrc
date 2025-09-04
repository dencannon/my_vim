" =======================
"  Minimal .vimrc (Vim)
" =======================

set nocompatible
set encoding=utf-8

" 1) Filetype & syntax & colors
filetype plugin indent on
syntax on
if has('termguicolors')
  set termguicolors
endif

" 2) Line numbers
set number

" 3) System clipboard by default
"    NOTE: requires Vim with +clipboard (or use Neovim).
set clipboard=unnamedplus

" 4) Map CTRL+SHIFT+C to copy to system clipboard
"    Visual mode -> copy selection, Normal mode -> copy line
vnoremap <C-S-c> "+y
nnoremap <C-S-c> "+yy

" 5) Plugins via vim-plug
"    Install vim-plug if missing: see install script.
call plug#begin('~/.vim/plugged')
  " --- Languages ---
  Plug 'pangloss/vim-javascript'        " JavaScript
  Plug 'maxmellon/vim-jsx-pretty'       " JSX/React
  Plug 'HerringtonDarkholme/yats.vim'   " TypeScript
  Plug 'elixir-editors/vim-elixir'      " Elixir
  Plug 'preservim/nerdtree'             " NERDTree
  Plug 'tpope/vim-commentary'
  " C, JSON, YAML have decent built-in syntax; add YAML if desired:
  " Plug 'stephpy/vim-yaml'

  " --- Search / Fuzzy Finder ---
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'

  " --- Git signs in gutter (changes vs HEAD) ---
  Plug 'airblade/vim-gitgutter'

  " --- Color schemes
  Plug 'sjl/badwolf'       " Bad Wolf (тёмная)
call plug#end()

" 6) ripgrep as :grep backend (if installed)
if executable('rg')
  set grepprg=rg\ --vimgrep\ --smart-case
  set grepformat=%f:%l:%c:%m
endif

" 7) Filename search & project-wide text search
let mapleader = " "

" Fuzzy file finder (current dir / project)
nnoremap <leader>ff :Files<CR>

" Live text search across files (ripgrep)
nnoremap <leader>fg :Rg<Space>

" Buffers / History
nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>fh :History<CR>

" Built-in filename search fallback
set path+=**
set wildmenu
nnoremap <leader>fp :find 

" 8) GitGutter: basic config (optional tweaks)
let g:gitgutter_map_keys = 0
nnoremap ]c :GitGutterNextHunk<CR>
nnoremap [c :GitGutterPrevHunk<CR>
nnoremap <leader>hp :GitGutterPreviewHunk<CR>
nnoremap <leader>hs :GitGutterStageHunk<CR>
nnoremap <leader>hu :GitGutterUndoHunk<CR>

nnoremap <C-n> :NERDTreeToggle<CR>

let NERDTreeQuitOnOpen=1
let g:NERDTreeWinPos = "left"

" 9) Better defaults (optional quality-of-life)
set hidden
set updatetime=300
set signcolumn=yes

set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

let macvim_skip_colorscheme = 1

colorscheme badwolf
" End of .vimrc
