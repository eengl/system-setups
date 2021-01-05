#!/bin/sh

if [ $# -eq 0 ]; then
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
   brew install $(cat brew-macos-packages.txt | grep -v '^#')
   #brew cask install opensc
elif [ "$1" == "uninstall" ]; then
   ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)"
fi
