#!/bin/bash
#set -x

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
# Run script only as root
# ---------------------------------------------------------------------------------------- 
if [ $(/usr/bin/id -u) -ne 0 ]; then
   echo "error: Script must be run by root"
   exit 1
fi

# ---------------------------------------------------------------------------------------- 
# Add some options to dnf.conf to improve performance
# ---------------------------------------------------------------------------------------- 
echo "max_parallel_downloads=10" >> /etc/dnf/dnf.conf
echo "fastestmirror=True" >> /etc/dnf/dnf.conf

# ---------------------------------------------------------------------------------------- 
# Install packages
# ---------------------------------------------------------------------------------------- 
dnf update
dnf install $(grep -v '^#' fedora/fedora-packages.txt)

# ---------------------------------------------------------------------------------------- 
#  Check if Google Chrome is installed.  If not download and install
# ---------------------------------------------------------------------------------------- 
CHROMEURL="https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm"
rpm -qa google-chrome-stable > /dev/null
if [ $? -ne 0 ]; then
   wget -P /tmp $CHROMEURL
   rpm -ivh /tmp/google-chrome-stable_current_x86_64.deb
fi

# ---------------------------------------------------------------------------------------- 
# Update system crypto policies.
# ---------------------------------------------------------------------------------------- 
update-crypto-policies --set LEGACY

# ---------------------------------------------------------------------------------------- 
# Set memory paging/swapping settings
# ---------------------------------------------------------------------------------------- 
echo "" >> /etc/sysctl.conf
echo "vm.swappiness = 10" >> /etc/sysctl.conf
echo "vm.vfs_cache_pressure = 50" >> /etc/sysctl.conf
