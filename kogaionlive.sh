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
	/usr/sbin/useradd -u 10000 -g 100 -o -m -s /bin/bash "$liveuser" > /dev/null 2>&1
}

kogaion_live_user_groups() {
	for group in tty disk lp wheel uucp console audio cdrom tape video cdrw usb plugdev messagebus portage ; do
		gpasswd -a "$liveuser" "$group" > /dev/null 2>&1
	done
}

kogaion_live_user_password () {
	/usr/bin/passwd --delete "$liveuser" > /dev/null 2>&1
}

main () {
	if checkroot ; then
		kogaion_add_live_user
		kogaion_live_user_groups
		kogaion_live_user_password
	fi
}

main
exit 0
	
