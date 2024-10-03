# dotfiles

![Static Badge](https://img.shields.io/badge/linux-x?logo=linux&color=%23FCC624)
![Static Badge](https://img.shields.io/badge/macOS-x?logo=apple&color=%23000000)
![Static Badge](https://img.shields.io/badge/bash%2C%20zsh-x?label=shell)

I prefer declarative, platform agnostic configuration with templating over shell
scripting. I mainly use my dotfiles on development servers, notebooks,
github codespaces with. I built my dotfiles around these two projects

* [aliae](https://aliae.dev/) for my custom aliases, functions and initialization scripting
* [oh-my-posh](https://ohmyposh.dev/) for my prompt

## Installation

You need to install a [nerd font](https://www.nerdfonts.com/) on your local machine to display glyphs and icons.

```shell
git clone https://github.com/RTmecPI/dotfiles.git
cd dotfiles
./install.sh
```

Once installed, pull updates to your local repo.

Install.sh will

* install packages oh-my-posh and aliae to `~/.local/bin`.
* create links in `~` to the dotfiles in `src`.
* keep existing dotfiles as `.old`
* add a second remote and pull from it to keep dotfiles in synch

It is safe to run `install.sh` multiple times.

## Personal data and secrets

Personal data and secrets do not belong into git repositories. On ephemeral system like
github codespaces, you should inject them as managed secrets. On a persistent system an
easy and fairly safe option is to use a single `.env` file somewhere in your home
directory and limit the access rights to your user.

These dotfiles load the settings from a file `.private.env` in the user's home directory
-- if it exists.

See the file example.env for an example of personal data that is used by the scripts in
this dotfiles collection.

## Updating and synching dotfiles

I like to be able to easily update my dotfiles. So that when I improve my setup
during my work, I can immediately without any extra effort, update my dotfiles
repo.  In a github codespace, you have read access to your dotfiles.

And I like to keep more than one remote of my dotfiles as I'd like to
access them from different contexts. I want to keep them in synch.

I use environment variables to store access tokens for write access to my
dotfiles and to define a second remote repo. See example.env for the environment
variables. For github codespaces, you can store these as personal codespace
secrets.

Use the scripts `addSecondRemote.sh` and `addTokens.sh` to apply the settings.

In this configuration, `install.sh` adds the second remote but not the tokens.
To toggle write access and push to all remotes, you can do the following. `git pushall`
is a git alias configured by these dotfiles.

```shell
./addTokens.sh
git pushall
./addTokens.sh --remove
```
