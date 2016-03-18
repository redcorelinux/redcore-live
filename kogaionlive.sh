#!/usr/bin/env bash

export local liveuser="kogaion"
CMDLINE=$(cat /proc/cmdline 2> /dev/null)

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

kogaion_locale_switch () {
	local lang_toset=
	local keymap_toset=
	local k_env_update=false
	for boot_param in ${CMDLINE}; do
		case ${boot_param} in
			rd.locale.LANG=*)
                lang_toset="${boot_param/*=}"
                ;;
            vconsole.keymap=*)
                keymap_toset="${boot_param/*=}"
                ;;
        esac
    done
	if [[ "${lang_toset}" != "en_US.utf8" ]] ; then
		localectl set-locale LANG=${lang_toset} > /dev/null 2>&1
		k_env_update=true
	fi
	if [[ "${keymap_toset}" != "us" ]] ; then
		localectl set-keymap ${keymap_toset} > /dev/null 2>&1
	fi
	if [ k_env_update ] ; then 
		/usr/sbin/env-update --no-ldconfig > /dev/null 2>&1
	fi
}


main () {
	if checkroot ; then
		kogaion_locale_switch
		kogaion_add_live_user
		kogaion_live_user_groups
		kogaion_live_user_password
	fi
}

main
exit 0
	
