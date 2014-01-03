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
sudo aa-enforce /etc/apparmor.d/bin.ping
sudo aa-enforce /etc/apparmor.d/sbin.klogd
sudo aa-enforce /etc/apparmor.d/sbin.syslog-ng
sudo aa-enforce /etc/apparmor.d/sbin.syslogd
sudo aa-enforce /etc/apparmor.d/usr.bin.chromium-browser
sudo aa-enforce /etc/apparmor.d/usr.sbin.avahi-daemon
sudo aa-enforce /etc/apparmor.d/usr.sbin.dnsmasq
sudo aa-enforce /etc/apparmor.d/usr.sbin.identd
sudo aa-enforce /etc/apparmor.d/usr.sbin.mdnsd
sudo aa-enforce /etc/apparmor.d/usr.sbin.nmbd
sudo aa-enforce /etc/apparmor.d/usr.sbin.nscd
sudo aa-enforce /etc/apparmor.d/usr.sbin.smbd
sudo aa-enforce /etc/apparmor.d/usr.sbin.traceroute

echo "[] Installing Tor Browser Launcher"
sudo add-apt-repository -y ppa:micahflee/ppa
sudo apt-get update
sudo apt-get install -y torbrowser-launcher

echo "[] Turning on Tor Browser AppArmor profile"
sudo aa-enforce /etc/apparmor.d/usr.bin.torbrowser-launcher
sudo aa-enforce /etc/apparmor.d/torbrowser.start-tor-browser
sudo aa-enforce /etc/apparmor.d/torbrowser.Browser.firefox
sudo aa-enforce /etc/apparmor.d/torbrowser.Tor.tor

echo "[] Running Tor Browser Launcher for the first time"
torbrowser-launcher > /dev/null 2>&1 &

echo "[] TODO: Add custom AppArmor profiles for Chrome, Thunderbird, Pidgin, LibreOffice, Jitsi, Skype, VLC"

cd $PWD
