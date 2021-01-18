#!/usr/bin/env bash

export local liveuser="redcore"

checkRoot() {
	if [[ "$(whoami)" != root ]] ; then
		exit 1
	fi
}

checkLive() {
	if [[ ! -L "/dev/mapper/live-rw" ]] ; then
		exit 1
	fi
}

addLive() {
	/usr/sbin/useradd -u 1000 -g 100 -o -m -s /bin/bash "$liveuser" > /dev/null 2>&1
}

liveGroups() {
	for group in tty disk lp lpadmin wheel uucp console audio cdrom input tape games video cdrw usb plugdev messagebus portage smbshare ; do
		/usr/bin/gpasswd -a "$liveuser" "$group" > /dev/null 2>&1
	done
}

livePasswd() {
	passwd -d "$liveuser" > /dev/null 2>&1
}

liveLogin() {
	sed -e "0,/User=/s//User=redcore/" -e "0,/Session=/s//Session=plasma/" /etc/sddm.conf | tee /etc/sddm.conf.live  > /dev/null 2>&1
	mv /etc/sddm.conf.live /etc/sddm.conf  > /dev/null 2>&1
}

liveLocales() {
	export local keymap_toset="$(cat /proc/cmdline | cut -d " " -f5 | cut -d "=" -f2)"
	export local lang_toset="$(cat /proc/cmdline | cut -d " " -f6 | cut -d "=" -f2)"
	if [[ "$lang_toset" != "en_US.utf8" ]] || [[ "$keymap_toset" != "us" ]] ; then
		sed -i "s/keymap=\"us\"/keymap=\"$keymap_toset\"/g" /etc/conf.d/keymaps > /dev/null 2>&1
		setxkbmap $keymap_toset
		/usr/bin/eselect locale set "$lang_toset" > /dev/null 2>&1
		/usr/sbin/env-update --no-ldconfig > /dev/null 2>&1
	else
		/usr/bin/eselect locale set "en_US.utf8" > /dev/null 2>&1
		/usr/sbin/env-update --no-ldconfig > /dev/null 2>&1
	fi
}

liveInstaller() {
	cp "/usr/share/applications/calamares.desktop" "/home/"$liveuser"/Desktop"
	sed -i "s/"Name=Calamares"/"Name=Redcore\ Installer"/g" "/home/"$liveuser"/Desktop/calamares.desktop"
	chmod 755 "/home/"$liveuser"/Desktop/calamares.desktop"
}

main() {
	if checkRoot && checkLive ; then
		addLive
		liveGroups
		livePasswd
		liveLogin
		liveLocales
		liveInstaller
	fi
}

main
exit 0
