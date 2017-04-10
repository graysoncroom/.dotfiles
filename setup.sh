
echo "--- Installing and configuring Pathogen.."
mkdir -p ~/.vim/autoload ~/.vim/bundle
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

echo "execute pathogen#infect()
syntax on
filetype plugin indent on" >> ~/.vimrc

echo "--- Cloning Apple's Swift repo.."
git clone https://github.com/apple/swift/

echo "--- Copying plugin to Vim bundles.."
cp -r ./swift/utils/vim ~/.vim/bundle/
