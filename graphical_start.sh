#!/bin/bash


if [ -n "$(equo match --installed gnome-base/gdm -qv)" ]; then
	systemctl start gdm
elif [ -n "$(equo match --installed lxde-base/lxdm -qv)" ]; then
	systemctl start lxdm
elif [ -n "$(equo match --installed x11-misc/lightdm-base -qv)" ]; then
	systemctl start lightdm
elif [ -n "$(equo match --installed kde-base/kdm -qv)" ]; then
	systemctl start kdm
elif [ -n "$(equo match --installed x11-misc/slim -qv)" ]; then
	systemctl start slim
else
	systemctl start xdm
fi
