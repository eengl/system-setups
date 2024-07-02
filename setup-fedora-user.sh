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
# Make directories
# ---------------------------------------------------------------------------------------- 
if [ ! -d $HOME/.local/bin ]; then mkdir -p $HOME/.local/bin; fi

# ---------------------------------------------------------------------------------------- 
# Copy in .bash_profile and other hidden config files
# ---------------------------------------------------------------------------------------- 
mv $HOME/.bash_profile $HOME/.bash_profile.ORIG
cp -v fedora/dot-bash_profile $HOME/.bash_profile
ln -s $HOME/.bash_profile $HOME/.profile
cp -v common/dot-bash_functions $HOME/.bash_functions

# ---------------------------------------------------------------------------------------- 
# Setup VIM
# ---------------------------------------------------------------------------------------- 
cp -v common/dot-vimrc $HOME/.vimrc
mkdir -p $HOME/.vim/swapfiles
mkdir -p $HOME/.vim/colors
cp -v common/afterglow.vim $HOME/.vim/colors/afterglow.vim

# ---------------------------------------------------------------------------------------- 
# Setup SSH
# ---------------------------------------------------------------------------------------- 
mkdir -p $HOME/.ssh/tmp
cp -v common/ssh-config $HOME/.ssh/config

# ----------------------------------------------------------------------------------------
# Install PyEnv
# ----------------------------------------------------------------------------------------
curl https://pyenv.run | bash

# ----------------------------------------------------------------------------------------
# Setup Git Configuration
# ----------------------------------------------------------------------------------------
sed "s/<HOME>/$HOME/g" common/dot-gitconfig > $HOME/.gitconfig
for type in personal work
do
   echo " ===== Create GitHub User Config for $type ===== " 
   ./helpers/make-gitconfig-user.sh
done
