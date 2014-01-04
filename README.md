# Linux Harden

A script to run that hardens a newly set up desktop Linux computer. This script is for Ubuntu/Linux Mint at the moment. Just run `./harden.sh` to start.

## What this does

* Updates all the software on your computer
* Installs thunderbird, enigmail, pidgin-otr, keepassx, tor, and other software
* Installs [Tor Browser Launcher](https://github.com/micahflee/torbrowser-launcher)
* Installs Google Chrome (convinced by @headhntr)
* Replaces Chrome and Firefox browser profiles with ones with better defaults and privacy and security extensions installed (HTTPS Everywhere, Adblock Plus, Disconnect)
* Installs and turns on a firewall that blocks all incoming network connections
* Turns on default AppArmor profiles
* Adds custom AppArmor profiles for: Pidgin, Thunderbird

## To Do

* Write AppArmor profiles for Chrome, Pidgin, LibreOffice, Jitsi, Skype, VLC

