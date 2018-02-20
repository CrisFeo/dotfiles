# Dotfiles

Personal dotfiles.

![screenshot](https://raw.github.com/CrisFeo/dotfiles/master/screenshot.png)


## Install

When setting up a new computer perform the following steps:

1. Run `./dotfiles install stow` to install all required packages and stow
   configuration.

2. Install fonts located at `./fonts`.

3. Add the following line to your to your `.bash_profile`:

```
. "$HOME/.bashrc"
```

## Update

To merge remote changes to your machine's config, simple run the `dotfiles`
command again.

## Firefox customization

Firefox customization is accomplished through a custom user chrome CSS file. See
the `userChrome.css` file in the `firefox/` directory for instructions as there
is manual setup involved.
