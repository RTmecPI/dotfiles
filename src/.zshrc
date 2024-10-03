# source .zsh.old if it exists
# install.sh will rename an existing .zshrc to .zshrc.old
# we execute it here to keep all system settings
if [ -e $HOME/.zshrc.old ]
then
    source $HOME/.zshrc.old
fi

# set environment variables from env file
if [ -e $HOME/.private.env ]
then
    set -a && source .private.env && set +a
fi

# activate aliae
eval "$(~/.local/bin/aliae init zsh)"
