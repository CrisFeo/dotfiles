# Dotfiles

Personal dotfiles.

![terminal](https://raw.github.com/CrisFeo/dotfiles/master/terminal.png)


## Install

When setting up a new computer perform the following steps:

1. Run `./install.sh` to install all of the configs and required packages.

2. Install all fonts located at `./fonts`.

3. Add the following line to your to your `.bash_profile`:
```
source ~/.bash_profile_cfeo
```

## Update

To merge remote changes to your machine's config, simple run `./install.sh`
again. If any new fonts were added to `./fonts`, install them as well.

## Save

Most settings are symlinked so changes are automatically reflected in this
repo. Several applications do not play well with symlinks however so any
changes to their config files can be copied in using `./save.sh`.
