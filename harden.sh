#!/bin/bash

DIR=`pwd`
BROWSER_PROFILES=$DIR/browser_profiles
APPARMOR_PROFILES=$DIR/apparmor_profiles

cd /tmp

echo "[] Updating software on the system"
sudo apt-get update
sudo apt-get dist-upgrade -y

echo "[] Installing useful software"
sudo apt-get install -y thunderbird enigmail pidgin pidgin-otr keepassx network-manager-openvpn vim git gufw tor apparmor apparmor-utils apparmor-profiles libcurl3

echo "[] Turn on your filewall, close the window"
sudo gufw

echo "[] Installing Google Chrome"
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
rm google-chrome-stable_current_amd64.deb

echo "[] Adding hardened browser profiles"
mv ~/.config/google-chrome ~/.config/google-chrome.orig > /dev/null 2>&1
mkdir -p ~/.config
cp -r $BROWSER_PROFILES/google-chrome ~/.config
mv ~/.mozilla/firefox ~/.mozilla/firefox.orig > /dev/null 2>&1
mkdir -p ~/.mozilla
cp -r $BROWSER_PROFILES/firefox ~/.mozilla

echo "[] Installing Tor Browser Launcher"
sudo add-apt-repository -y ppa:micahflee/ppa
sudo apt-get update
sudo apt-get install -y torbrowser-launcher

echo "[] Enforcing built-in AppArmor profiles"
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

echo "[] Adding and enforcing custom AppArmor profiles"
sudo cp $APPARMOR_PROFILES/* /etc/apparmor.d/
sudo aa-enforce /etc/apparmor.d/usr.bin.pidgin
# thunderbird profile needs more work
sudo aa-disable /etc/apparmor.d/usr.lib.thunderbird.thunderbird

echo "[] TODO: Make custom AppArmor profiles for Chrome, LibreOffice, Jitsi, Skype, VLC"

echo "[] Turning on Tor Browser AppArmor profile"
sudo aa-enforce /etc/apparmor.d/usr.bin.torbrowser-launcher
sudo aa-enforce /etc/apparmor.d/torbrowser.start-tor-browser
sudo aa-enforce /etc/apparmor.d/torbrowser.Browser.firefox
sudo aa-enforce /etc/apparmor.d/torbrowser.Tor.tor

echo "[] Running Tor Browser Launcher for the first time"
torbrowser-launcher > /dev/null 2>&1 &

echo "[] Installing TrueCrypt"
TRUECRYPT_TARBALL=truecrypt-7.1a-linux-x64.tar.gz
TRUECRYPT_SIG=truecrypt-7.1a-linux-x64.tar.gz.sig
TRUECRYPT_SETUP=truecrypt-7.1a-setup-x64
gpg --import $DIR/truecrypt.asc
wget https://www.truecrypt.org/download/$TRUECRYPT_SIG
wget https://www.truecrypt.org/download/$TRUECRYPT_TARBALL
if gpg --verify $TRUECRYPT_SIG
then
    tar -xf $TRUECRYPT_TARBALL
    echo "[] Starting TrueCrypt installer: choose option 1 and follow instructions"
    /tmp/$TRUECRYPT_SETUP
else
    echo echo "[] WARNING: TrueCrypt signature verification failed, skipping installation"
fi

echo "[] Installing Jitsi"
wget https://download.jitsi.org/jitsi/debian/jitsi_2.5-latest_amd64.deb
sudo dpkg -i jitsi_2.5-latest_amd64.deb
sudo apt-get install -f

echo "[] Update the Cinnamon panel (for Linux Mint)"
gsettings set org.cinnamon panel-launchers "['google-chrome.desktop', 'thunderbird.desktop', 'pidgin.desktop', 'gnome-terminal.desktop', 'torbrowser.desktop', 'keepassx.desktop', 'nemo.desktop']"

cd $DIR
