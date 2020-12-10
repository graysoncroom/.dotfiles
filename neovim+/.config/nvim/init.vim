" vim != vi
set nocompatible

" This will install the plugin manager if it is not already installed.
if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'christoomey/vim-tmux-navigator'  
Plug 'drewtempelmeyer/palenight.vim'    

call plug#end()

let mapleader="\<Space>"
let maplocalleader="\<Space>"

let g:palenight_terminal_italics=1
let g:tmux_navigator_save_on_switch = 2
let g:livepreview_previewer = 'zathura'

colorscheme palenight

filetype plugin indent on

nnoremap Y y$

nnoremap <localleader>ev :vsplit<CR>
nnoremap <localleader>es :split<CR>

" ==== General ====
set shell=bash        " Make sure the shell is bash on every system.
set listchars=tab:>.  " Visual representation of certain characters when list is set.
set list              " listing of invisible characters (personal preference).
set undolevels=100000 " Set the number of undo levels vim will record.
set bg=dark           " Background colors should be either light or dark
set encoding=utf-8    " File encoding will be in unicode.
set ttimeoutlen=0     " key code delay (see timeoutlen for mapping delays)
set cursorline        " highlight line cursor is on

" ==== Line Numbers ====
set number         " Show line numbers in the gutter.
set relativenumber " Show how many lines each line is away from the current line

" ==== Indentation ====
set autoindent   " Enable automatic indentation.
set shiftwidth=4 " Used by >>, <<, and ==. Also affects how auto-indentation works.
set tabstop=4    " Changes the width of the tab character.
set expandtab    " Replace tabs with spaces. Comment this line out to use hard tabs.

" ==== Folding ====
set foldenable
set foldmethod=syntax

" ==== File Specific Indentation ====
autocmd filetype lisp set shiftwidth=2
autocmd filetype lisp set tabstop=2
autocmd filetype lisp set expandtab

autocmd filetype c set tabstop=4
autocmd filetype c set noexpandtab

" ==== Boilerplates ====
autocmd filetype java nnoremap <localleader>b gg:r ~/.vim/boilerplates/java<CR>ggdd:s/NAME/<C-r>=expand("%:r")<CR><CR>2Go
autocmd filetype c    nnoremap <localleader>b gg:r ~/.vim/boilerplates/c<CR>ggdd/{<CR>o
autocmd filetype html nnoremap <localleader>b gg:r ~/.vim/boilerplates/html<CR>ggdd/<title><CR>f>a<C-r>=expand("%:r")<CR><esc>/<body><CR>o

" Corporate Comment Boilerplate
nnoremap <localleader>* mp:r ~/.vim/boilerplates/comment<cr>'pdd=5j/DATE<cr>dawk:r! date +\%m/\%d/\%Y<cr>J==i* <esc>2Wi  <esc>?Description<cr>nciw
