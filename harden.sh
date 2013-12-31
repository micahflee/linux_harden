#!/bin/bash

PWD=`pwd`
cd /tmp

echo "[] Updating software on the system"
sudo apt-get update
sudo apt-get dist-upgrade -y

echo "[] Installing useful software"
sudo apt-get install -y enigmail pidgin pidgin-otr keepassx network-manager-openvpn vim git gufw tor apparmor apparmor-utils apparmor-profiles libcurl3

echo "[] Turn on your filewall, close the window"
sudo gufw

echo "[] Installing Chrome"
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
rm google-chrome-stable_current_amd64.deb

echo "[] TODO: Adding hardened browser profiles"

echo "[] Configuring AppArmor"
sudo aa-enforce /etc/apparmor.d/usr.bin.firefox
sudo aa-enforce /etc/apparmor.d/usr.sbin.rsyslogd
sudo aa-enforce /etc/apparmor.d/system_tor

echo "[] Installing Tor Browser Launcher"
sudo add-apt-repository ppa:micahflee/ppa
sudo apt-get update
sudo apt-get install -y torbrowser-launcher

echo "[] TODO: Turning on Tor Browser AppArmor profile"

echo "[] Running Tor Browser Launcher for the first time"
torbrowser-launcher > /dev/null 2>&1 &

echo "[] TODO: Add custom AppArmor profiles for Chrome, Thunderbird, Pidgin, LibreOffice, Jitsi, Skype, VLC"

cd $PWD
