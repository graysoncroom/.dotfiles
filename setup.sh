#!/bin/bash

# I am very new to shell scripting. All comments on what I should improve are welcome!

# Start log for ease of debugging
echo "Start of script log: $(date)" >> /tmp/dotfile-update.log

DIRECTORY_BEFORE_DOTFILE_INSTALL=$(pwd)
DOTFILE_INSTALL_GITHUB_LINK="https://github.com/graysoncroom/.dotfiles.git"

echo "Before you continue, make sure you backup and remove conflicting dotfiles from your home
directory."
echo "You can see the dotfiles that will be installed at $DOTFILE_INSTALL_GITHUB_LINK"
echo "Enter any key if you want to continue (nothing bad will happen but results will be half assed): "
echo "To stop program press <C-c>"
read

# Clone repo and go into dotfiles directory
cd ~
git clone $DOTFILE_INSTALL_GITHUB_LINK 2> /tmp/dotfile-update.log
cd .dotfiles

# The files that should be stowed
stow_files=$(ls | grep +)

# Stow those files
for file in $stow_files; do
    stow $file 2> /tmp/dotfile-update.log
done

# A crappy log that may help you get some error infomation
echo "Files that should have been stowed:" >> /tmp/dotfile-update.log
echo "$stow_files" >> /tmp/dotfile-update.log

# End log
echo "End of script log: $(date)" >> /tmp/dotfile-update.log

cd DIRECTORY_BEFORE_DOTFILE_INSTALL
unset DIRECTORY_BEFORE_DOTFILE_INSTALL
unset stow_files
