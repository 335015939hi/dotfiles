# Dotfiles

My personal Linux configuration files and setup scripts.

The `main` branch contains configuration that is intended to be usable independently of a specific desktop environment.

## Installation

Clone the repository and run the installer:

```bash
git clone https://github.com/335015939hi/dotfiles.git
cd dotfiles
./install.sh
```

The installer creates symlinks from the repository into the appropriate locations in `$HOME`.

Existing files are backed up

## Branches

### `main`

The common configuration and base installation.

### `plasma`

A KDE Plasma-specific configuration built on top of `main`. 
