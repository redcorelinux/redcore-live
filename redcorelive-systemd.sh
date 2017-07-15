#!/usr/bin/env bash

export local liveuser="redcore"

checkroot() {
	if [[ "$(whoami)" != root ]] ; then
		echo "No root, no play! Bye bye!"
		exit 1
	fi
}

redcore_is_live() {
	if [[ ! -L "/dev/mapper/live-rw" ]] ; then
		echo "The system is not running in live mode, aborting!"
		exit 1
	fi
}

redcore_add_live_user() {
	/usr/sbin/useradd -u 1000 -g 100 -o -m -s /bin/bash "$liveuser" > /dev/null 2>&1
}

redcore_live_user_groups() {
	for group in tty disk lp wheel uucp console audio cdrom tape kvm cdemu games video vboxsf vboxguest cdrw usb plugdev messagebus portage ; do
		gpasswd -a "$liveuser" "$group" > /dev/null 2>&1
	done
}

redcore_live_user_password() {
	echo "$liveuser":"$liveuser" | /usr/sbin/chpasswd > /dev/null 2>&1
}

redcore_live_locale_switch() {
	export local keymap_toset="$(cat /proc/cmdline | cut -d " " -f5 | cut -d "=" -f2)"
	export local lang_toset="$(cat /proc/cmdline | cut -d " " -f6 | cut -d "=" -f2)"
	if [[ "$lang_toset" != "en_US.utf8" ]] || [[ "$keymap_toset" != "us" ]] ; then
		/usr/bin/localectl set-locale LANG="$lang_toset" > /dev/null 2>&1
		/usr/bin/localectl set-keymap "$keymap_toset" > /dev/null 2>&1
		/usr/sbin/env-update --no-ldconfig > /dev/null 2>&1
	fi
}

redcore_live_installer_desktop() {
	cp "/usr/share/applications/calamares.desktop" "/home/"$liveuser"/Desktop"
	sed -i "s/"Name=Calamares"/"Name=Redcore\ Installer"/g" "/home/"$liveuser"/Desktop/calamares.desktop"
	chmod 755 "/home/"$liveuser"/Desktop/calamares.desktop"
}

main() {
	if checkroot && redcore_is_live ; then
		redcore_add_live_user
		redcore_live_user_groups
		redcore_live_user_password
		redcore_live_installer_desktop
		redcore_live_locale_switch
	fi
}

main
exit 0
