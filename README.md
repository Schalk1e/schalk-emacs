# Use

Credit for writing this nifty emacs config that I've adapted for my purposes:  https://github.com/jerith/jerith-emacs. (Kindly reference this repository for licensing details.)

Emacs looks at ~/.emacs.d/init.el for any custom configuration the user
requires.This repository uses an org file (`emacs-init.org`) that is 'compiled
and tangled' into an `emacs-init.el` file. This is called from `init.el`. In
order to import this config, copy `init.el`, `emacs-init.org` and `emacs-init.el`
into ~/.emacs.d and start emacs.

## Steps

### LSP Support

This config makes use of LSPs for some languages. The ones in active use are installed into a virtual environment using `uv`. To install these run:

`uv sync`

### Tangling

In `emacs-init.org` make any config changes required and tangle the output as described above. (`C-c C-v t` in emacs.)

### Syncing

Finally execute `./scripts/sync.sh` to sync the config files to `~/.emacs.d/`.

# Documentation

For the full documentation on the various constituent parts of this config, see [here](emacs-init.org).
