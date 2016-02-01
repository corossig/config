#!/bin/sh

for i in .bashrc .emacs/.emacs .emacs/.emcas.d .fonts .gdbinit .gitconfig .pystartup .screenrc .shellrc .Xresources .zshrc
do
    ln -sf $PWD/$i ~/
done

rm ~/.ssh/authorized_keys
ln -sf $PWD/authorized_keys ~/.ssh/authorized_keys
