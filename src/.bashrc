# source .bashrc.old if it exists
# install.sh will rename an existing .bashrc to .bashrc.old
# we execute it here to keep all system settings
if [ -e $HOME/.bashrc.old ]; then
    source $HOME/.bashrc.old
fi

# set environment variables from env file
if [ -e $HOME/.private.env ]
then
    set -a && source .private.env && set +a
fi

# activate aliae
eval "$(~/.local/bin/aliae init bash)"
