#!/bin/bash
set -euo pipefail

configOriginToken=${DOTFILES_ORIGIN_TOKEN:-}
originToken=$configOriginToken
secondRemote=${DOTFILES_SECOND_REMOTE:-private}
configSecondToken=${DOTFILES_SECOND_TOKEN:-}
secondToken=$configSecondToken


# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            echo "$0"
            echo ""
            echo "Execute this script in the root directory of your local dotfiles repo."
            echo "This script adds access tokens to the remotes. Use these access tokens to"
            echo "provide write access in an environment in which you do not have write access"
            echo "by default."
            echo "The tokens can be configured via environment vaiables."
            echo "  DOTFILES_ORIGIN_TOKEN   Token to add to the url of remote 'origin'"
            echo "  DOTFILES_SECOND_TOKEN   Token to add to the url of second remote (DOTFILES_SECOND_REMOTE)"
            echo ""
            echo "Each token is added to the url, or if credentials are found in url, replaces those"
            echo "with the given token. URLs must start with hppts://"
            echo ""
            echo "Exit errors"
            echo " - URL of remotes must start with https:// "
            echo ""
            echo "Options"
            echo " -h / --help   Displays this help text."
            exit 0
            ;;
        --remove)
            originToken=""
            secondToken=""
            shift
            ;;
        *)
            echo "Error: Unknown argument $1"
            exit 2
            ;;
    esac
done

# makeUrlWithToken URL TOKEN
#
# Add TOKEN to the URL, or if credentials are found in URL, replaces those
# with the given TOKEN. URLs must start with hppts://
# If TOKEN is empty, any token data is removed from URL
#
# Args:
# - URL: The url to which the token is added.
# - TOKEN: The token to add, empty or not set to remove tokens from URL
#
# exits on:
# URL does not start with "htps://"
#
# echos:
# roughly speaking: TOKEN@URL or URL
makeUrlWithToken() {
    url=$1
    token=${2:-}
    if [[ ! $url == "https://"* ]]
    then
        echo "Error: Url needs to use https protocol to add token. url: $url"
        exit 1
    fi
    urlPath=${url:8}
    if [[ $url == *"@"* ]]
    then
        # the space after the third / is important \_(*.*)_/
        parts=(${urlPath//@/ })
        urlPath=${parts[1]}
    fi

    if [ -z "$token" ]
    then
        echo "https://$urlPath"
    else
        echo "https://${token}@${urlPath}"
    fi
}

remoteAddToken() {
    remote=$1
    token=${2:-}

    # Get url of remote and do not fail on error
    set +e
    url=$(git remote get-url $remote 2>/dev/null)
    gitError=$?
    set -e
    if [ $gitError != 0 ]
    then
        echo "Skipped: No such remote '${remote}'."
        return
    fi

    urlWithToken=$(makeUrlWithToken $url $token)
    git remote set-url $remote $urlWithToken
}

# change access rights of local git config before adding the token
chmod 600 .git/config

if [ -n "$configOriginToken" ]
then
    remoteAddToken origin $originToken
fi

if [ -n "$configSecondToken" ]
then
    if [ -z "$secondRemote" ]
    then
        echo "Error: Token for second remote configured (DOTFILES_SECOND_TOKEN) but without a remote name (DOTFILES_SECOND_REMOTE)."
        exit 1
    fi
    remoteAddToken $secondRemote $secondToken
fi
