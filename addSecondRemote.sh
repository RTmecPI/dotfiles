#!/bin/bash
set -euo pipefail

remote=${DOTFILES_SECOND_REMOTE:-private}
repo=${DOTFILES_SECOND_REPO:-}
userName=${DOTFILES_USER_NAME:-}
userEmail=${DOTFILES_USER_EMAIL:-}

pull=0


# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --pull)
            pull=1
            shift # past argument
            ;;
        -h|--help)
            echo "$0 [--pull]"
            echo ""
            echo "Execute this script in the root directory of your local dotfiles repo."
            echo "It will add a second remote to the local repository. The repository "
            echo "is configured by the following environment variables:"
            echo "  DOTFILES_SECOND_REMOTE  the name of the remote as used in git push <remote>"
            echo "  DOTFILES_SECOND_REPO    url of the remote repo."
            echo ""
            echo "If DOTFILES_USER_NAME is set, the script will also set the git user name"
            echo "and email to the values of the environment variables DOTFILES_USER_NAME"
            echo "and DOTFILES_USER_EMAIL. git will use these values for all commits to"
            echo "the dotfiles repo."
            echo ""
            echo "If DOTFILES_SECOND_REPO is not set the script does nothing."
            echo ""
            echo "Options"
            echo " --pull        Calls git pull <remote> after adding the remote."
            echo " -h / --help   Displays this help text."
            exit 0
            ;;
        *)
            echo "Error: Unknown argument $1"
            exit 2
            ;;
    esac
done

if [ -n "$repo" ]
then
    if git remote -v | grep "$remote" > /dev/null
    then
        git remote set-url $remote $repo
    else
        git remote add $remote $repo
    fi
    if [ "$pull" -eq 1 ]
    then
        branch=$(git branch --show-current)
        git pull $remote $branch
    fi
else
    echo "No private dotfiles repo configured. No remote added."
fi

if [ -n "$userName" ]
then
    git config user.name "$userName"
    git config user.email "$userEmail"
    echo "Local git identity set to"
    git config --local user.name
    git config --local user.email
fi
