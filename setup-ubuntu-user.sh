#!/bin/sh
set -x

# ---------------------------------------------------------------------------------------- 
# Check for Ubuntu
# ---------------------------------------------------------------------------------------- 
if [ -f /etc/os-release ]; then
   if [[ $(grep '^ID'"=" /etc/os-release) != "ID=ubuntu" ]]; then
       echo "ERROR: System is Linux, but is not Ubuntu"
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
# Update .bashrc 
# ---------------------------------------------------------------------------------------- 
echo "" > /tmp/add_to_bashrc
echo "if [ -f ~/.bash_profile ]; then" >> /tmp/add_to_bashrc
echo "   . ~/.bash_profile" >> /tmp/add_to_bashrc
echo "fi" >> /tmp/add_to_bashrc
PERMS=$(stat -c "%a" $HOME/.bashrc)
cat $HOME/.bashrc /tmp/add_to_bashrc > /tmp/new_bashrc
cp -v $HOME/.bashrc $HOME/.bashrc.BAK
cp -v /tmp/new_bashrc $HOME/.bashrc
chmod $PERMS $HOME/.bashrc

# ---------------------------------------------------------------------------------------- 
# Copy in .bash_profile and other hidden config files
# ---------------------------------------------------------------------------------------- 
mv $HOME/.profile $HOME/.profile.BAK
cp -v ubuntu/dot-bash_profile $HOME/.bash_profile
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
# Center windows
# ----------------------------------------------------------------------------------------
gsettings set org.gnome.mutter center-new-windows true
