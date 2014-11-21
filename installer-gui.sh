#!/bin/bash

. /sbin/kogaion-functions.sh

if kogaion_is_gui_install; then
	kogaion_setup_autologin
	kogaion_setup_gui_installer
fi
