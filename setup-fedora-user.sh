#!/bin/sh
set -x

# ---------------------------------------------------------------------------------------- 
# Check for Fedora
# ---------------------------------------------------------------------------------------- 
if [ -f /etc/os-release ]; then
   if [[ $(grep '^ID'"=" /etc/os-release) != "ID=fedora" ]]; then
       echo "ERROR: System is Linux, but is not Fedora"
       exit 1
   fi
else
   echo "ERROR: System is not Linux."
   exit 1
fi

# ---------------------------------------------------------------------------------------- 
# Make a local bin directory
# ---------------------------------------------------------------------------------------- 
if [ ! -d $HOME/.local/bin ]; then mkdir -p $HOME/.local/bin; fi

# ---------------------------------------------------------------------------------------- 
# Copy in .bash_profile and other hidden config files
# ---------------------------------------------------------------------------------------- 
mv $HOME/.bash_profile $HOME/.bash_profile.ORIG
cp fedora/dot-bash_profile $HOME/.bash_profile
ln -s $HOME/.bash_profile $HOME/.profile
cp common/dot-bash_functions $HOME/.bash_functions

# ---------------------------------------------------------------------------------------- 
# Setup VIM
# ---------------------------------------------------------------------------------------- 
cp common/dot-vimrc $HOME/.vimrc
mkdir -p $HOME/.vim/swapfiles

# ---------------------------------------------------------------------------------------- 
# Setup SSH
# ---------------------------------------------------------------------------------------- 
mkdir -p $HOME/.ssh/tmp
cp common/ssh-config $HOME/.ssh/config
