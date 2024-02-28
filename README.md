# An Emacs Config Shamelessly Stolen from https://github.com/jerith/jerith-emacs

## How to use this condensed version

Emacs looks for ~/.emacs.d/init.el for any custom configuration the user
requires.This repository uses an org file (`emacs-init.org`) that is 'compiled
and tangled' into an `emacs-init.el` file. This is called from `init.el`. In
order to import this config, copy `init.el`, `emacs-init.org` and `emacs-init.el`
into ~/.emacs.d and start emacs.

## WSL

It wanted me to install some things (use-packages) manually. Also to add melpa and gnu to the package-archives. Uncomment line 10-11 in `init.el` for this. Best of luck!
