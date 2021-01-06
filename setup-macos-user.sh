#!/bin/sh

# ---------------------------------------------------------------------------------------- 
# Setup script for macOS
# ---------------------------------------------------------------------------------------- 

THISDIR=$PWD

# ---------------------------------------------------------------------------------------- 
# Create directories
# ---------------------------------------------------------------------------------------- 
mkdir -p .local/bin
mkdir -p .ssh/tmp
mkdir -p .vim/swapfiles

# ---------------------------------------------------------------------------------------- 
# Install user's bash profile scripts
# ---------------------------------------------------------------------------------------- 
if [ -f $HOME/.bash_profile ]; then
   cp $HOME/.bash_profile $HOME/.bash_profile.ORIG
fi
cp macos/dot-bash_profile $HOME/.bash_profile
if [ -f $HOME/.profile ]; then
   cp $HOME/.profile $HOME/.profile.ORIG
fi
cp macos/dot-bash_logout $HOME/.bash_logout
cp common/dot-bash_functions $HOME/.bash_functions

cd $HOME
ln -sf .bash_profile .profile
cd $THISDIR

# ---------------------------------------------------------------------------------------- 
# Vim config file
# ---------------------------------------------------------------------------------------- 
cp common/dot-vimrc $HOME/.vimrc

# ---------------------------------------------------------------------------------------- 
# SSH config file
# ---------------------------------------------------------------------------------------- 
cp common/ssh-config $HOME/.ssh/config
