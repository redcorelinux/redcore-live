#!/usr/bin/env bash

export local liveuser="kogaion"

checkroot () {
	if [[ "$(whoami)" != root ]] ; then
		echo ""
		echo "You're not root?...No cookies for you, go away !!!"
		echo ""
		exit 1
	fi
}

kogaion_add_live_user() {
	/usr/sbin/useradd -u 1000 -g 100 -o -m -s /bin/bash "$liveuser" > /dev/null 2>&1
}

kogaion_live_user_groups() {
	for group in tty disk lp wheel uucp console audio cdrom tape video cdrw usb plugdev messagebus portage ; do
		gpasswd -a "$liveuser" "$group" > /dev/null 2>&1
	done
}

kogaion_live_user_password () {
	/usr/bin/passwd --delete "$liveuser" > /dev/null 2>&1
}

kogaion_live_locale_switch () {
	export local keymap_toset="$(cat /proc/cmdline | cut -d " " -f12 | cut -d "=" -f2)"
	export local lang_toset="$(cat /proc/cmdline | cut -d " " -f13 | cut -d "=" -f2)"
	if [[ "$lang_toset" != "en_US.utf8" ]] || [[ "$keymap_toset" != "us" ]] ; then
		/usr/bin/localectl set-locale LANG="$lang_toset" > /dev/null 2>&1
		/usr/bin/localectl set-keymap "$keymap_toset" > /dev/null 2>&1
		/usr/sbin/env-update --no-ldconfig > /dev/null 2>&1
	fi
}


main () {
	if checkroot ; then
		kogaion_add_live_user
		kogaion_live_user_groups
		kogaion_live_user_password
		kogaion_live_locale_switch
	fi
}

main
exit 0
	
