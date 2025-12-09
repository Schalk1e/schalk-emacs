#! /bin/bash

echo "Copying pylsp virtual environment into ~/.emacs.d/..."

# Set scripts directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Copy venv and .el config files o ~/.emacs.d/
cp -r "$SCRIPT_DIR"/../{init.el,emacs-init.el,.venv} ~/.emacs.d/
