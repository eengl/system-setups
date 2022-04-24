#!/bin/bash
#set -x

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
# Run script only as root
# ---------------------------------------------------------------------------------------- 
if [ $(/usr/bin/id -u) -ne 0 ]; then
   echo "error: Script must be run by root"
   exit 1
fi

# ---------------------------------------------------------------------------------------- 
# Install packages
# ---------------------------------------------------------------------------------------- 
apt-get update
apt-get install $(cat ubuntu/ubuntu-packages.lst)

# ---------------------------------------------------------------------------------------- 
#  Check if Google Chrome is installed.  If not download and install
# ---------------------------------------------------------------------------------------- 
CHROMEURL="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
dpkg -s google-chrome-stable > /dev/null
if [ $? -ne 0 ]; then
   wget -P /tmp $CHROMEURL
   dpkg --install /tmp/google-chrome-stable_current_amd64.deb
fi

# ---------------------------------------------------------------------------------------- 
# Set memory paging/swapping settings
# ---------------------------------------------------------------------------------------- 
echo "" >> /etc/sysctl.conf
echo "vm.swappiness = 10" >> /etc/sysctl.conf
echo "vm.vfs_cache_pressure = 50" >> /etc/sysctl.conf
