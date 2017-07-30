# dotfiles
Feel free to steal ideas or whatever from my configs. 

Please note that most of the configs are tightly coupled with one another. Pull requests for new abstractions/bug fixes are always welcome!

## Quick Info
i3-gaps -> { i3bar i3blocks i3lock }

vim -> { See `vim+/.vim/vimrc` }

firefox -> { vimperator|vimfx }

mutt

ranger

zathura

much more...

### Why are your dotfiles 99% Java?
There is a copy of the jdk-1.8.0 library in the directory: vim/.java-source
This will be replaced with a script that installs, decompresses, and extracts the latest java library into vim/.java-source.

### What dotfile manager is used in this project?
I use `Gnu stow`, but there is nothing about this project that prevents you from doing it another way.
Stow is awesome and you should check it out!

### Why do you have i3-gaps and chunkwm configs?
I use i3-gaps on all my linux systems, but at work I use chunkwm 'my' mac.

### i3 vs i3-gaps
i3-gaps allows you to put space between windows that are tiled.
Nice on a high resolution monitor when you only have a couple applications open.

### Why is there a plus after many of the directory names?
It allows scripts to easily identify which directories are 'stowable'.

Example: Stow all stowable directories not including the vim configs
```
#!/bin/env bash
cd ~/.dotfiles
for stowable_file in $(ls | grep +); do
    if [ $stowable_file != "vim+" ]; then
        stow $stowable_file
    fi
done
cd -
```

### How do I install all of your configs at once?
You can use the script I provide to install them all. It is called: setup.sh
Please make sure there are no dotfiles that will conflict with the ones in this repo. 
If you don't, nothing will happend to your configs, but at the same time you won't get the ones from this project.
Stow does not override files that are already there.
The script logs to /tmp/dotfile-update.log. If there was an error stowing something you will see the error message there.
