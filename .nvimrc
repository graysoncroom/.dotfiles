" Required NeoBundle Scripts
if has('vim_starting')  
  set runtimepath+=~/.config/nvim/bundle/neobundle.vim/
  set runtimepath+=~/.config/nvim/
endif

let neobundle_readme=expand('~/.config/nvim/bundle/neobundle.vim/README.md')

if !filereadable(neobundle_readme)  
  echo "Installing NeoBundle..."
  echo ""
  silent !mkdir -p ~/.config/nvim/bundle
  silent !git clone https://github.com/Shougo/neobundle.vim ~/.config/nvim/bundle/neobundle.vim/
  let g:not_finsh_neobundle = "yes"
endif

" =========================================
" |----- Start of NeoVim Plugin List -----|
" =========================================
call neobundle#begin(expand('$HOME/.config/nvim/bundle'))  

NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'PotatoesMaster/i3-vim-syntax'
NeoBundle 'keith/swift.vim'
NeoBundle 'vim-syntastic/syntastic'
NeoBundle 'scrooloose/nerdtree.git'
NeoBundle 'rustushki/JavaImp.vim'
NeoBundle 'jpalardy/vim-slime'
NeoBundle 'kovisoft/slimv'
NeoBundle 'adolenc/cl-neovim'
NeoBundle 'christoomey/vim-tmux-navigator'

call neobundle#end()  
filetype plugin indent on
" =========================================
" |------ End of NeoVim Plugin List ------|
" =========================================

NeoBundleCheck  

source ~/.generic-vimrc
