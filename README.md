## Use

Credit for writing this nifty emacs config that I've adapted for my purposes:  https://github.com/jerith/jerith-emacs.

Emacs looks for ~/.emacs.d/init.el for any custom configuration the user
requires.This repository uses an org file (`emacs-init.org`) that is 'compiled
and tangled' into an `emacs-init.el` file. This is called from `init.el`. In
order to import this config, copy `init.el`, `emacs-init.org` and `emacs-init.el`
into ~/.emacs.d and start emacs.
