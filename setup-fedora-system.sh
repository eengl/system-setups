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
   rpm -ivh /tmp/google-chrome-stable_current_x86_64.rpm
fi

# ---------------------------------------------------------------------------------------- 
# Install 1Password
# ---------------------------------------------------------------------------------------- 
rpm --import https://downloads.1password.com/linux/keys/1password.asc
echo -e "[1password]\nname=1Password Stable Channel\nbaseurl=https://downloads.1password.com/linux/rpm/stable/\$basearch\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=\"https://downloads.1password.com/linux/keys/1password.asc\"" > /etc/yum.repos.d/1password.repo
dnf install 1password

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

# ---------------------------------------------------------------------------------------- 
# Start SSH Server
# ---------------------------------------------------------------------------------------- 
systemctl enable sshd
systemctl start sshd

# ---------------------------------------------------------------------------------------- 
# Update script for root.
# ---------------------------------------------------------------------------------------- 
echo "#!/bin/sh" >> $HOME/update
echo "dnf update" >> $HOME/update
echo "dnf autoremove" >> $HOME/update
echo "dnf clean dbcache" >> $HOME/update
chmod 700 $HOME/update
