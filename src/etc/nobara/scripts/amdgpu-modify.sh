#!/usr/bin/bash

# Detect if an amdgpu is present

amdgpu=$(lspci | grep -iE 'VGA|3D' | grep -i amd | cut -d ":" -f 3)

 if [[ ! -z $amdgpu ]]; then
    echo "amdgpu detected" && export "AMDGPU_DETECTED"=TRUE	
else
    echo "no amdgpu detected on your system"
fi

# Start 

if [[ "$AMDGPU_DETECTED" == TRUE ]]; then
	if zenity --question --text="We have detected modern AMD GPU hardware on your system! , would you like to install some additional drivers for extended functionality?"
	then
	zenity --warning --text="Some of this software is proprietary! ."
	
		
	
	# Clean and make tmp dir
	
	rm -r /tmp/zenity/nobara-amdgpu-config
	mkdir -p /tmp/zenity/nobara-amdgpu-config/
	
	# Get EULA
	
	wget https://raw.githubusercontent.com/CosmicFusion/nobara-amdgpu-config/main/RADEON-LICENSE.md -O /tmp/zenity/nobara-amdgpu-config/EULA

	if zenity --text-info --title="Radeon™ Software for Linux End User License Agreement" --filename=/tmp/zenity/nobara-amdgpu-config/EULA  --checkbox="I read and accept the terms." 
	then
		# Check for current packages
	
	rpm -qa | grep amdamf-pro-runtime && export "AMF_STATE"=TRUE || export "AMF_STATE"=FALSE
	rpm -qa | grep amdvlk-pro-2 && export "VLKPRO_STATE"=TRUE || export "VLKPRO_STATE"=FALSE
	rpm -qa | grep amdvlk-pro-legacy && export "VLKLEGACY_STATE"=TRUE || export "VLKLEGACY_STATE"=FALSE
	rpm -qa | grep amdvlk-2 && export "VLKOPEN_STATE"=TRUE || export "VLKOPEN_STATE"=FALSE
	rpm -qa | grep amdogl-pro && export "OGL_STATE"=TRUE || export "OGL_STATE"=FALSE
	rpm -qa | grep amdocl-legacy && export "OCL_STATE"=TRUE || export "OCL_STATE"=FALSE
	
	# Zenity list
	
	export COMP_SEC=$(zenity --list --column Selection --column Package --column Description \
	"$AMF_STATE" amdamf-pro-runtime 'AMD™ "Advanced Media Framework" can be used for H265/H264 encoding & decoding' \
	"$VLKPRO_STATE" amdvlk-pro 'AMD™ Proprietary Vulkan implementation can be used for HW ray-tracing & and is needed for AMF (this can be invoked by "$ vk_pro" from the amdgpu-vulkan-switcher package) '  \
	"$VLKLEGACY_STATE" amdvlk-pro-legacy 'AMD™ Pre 21.50 Proprietary Vulkan implementation can be used for HW ray-tracing & and is needed for AMF (this can be invoked by "$ vk_legacy" from the amdgpu-vulkan-switcher package) (only use if the normal amdvlk-pro does not work for you)'  \
	"$VLKOPEN_STATE" amdvlk 'AMD™ 1st party Vulkan implementation (this can be invoked by "$ vk_amdvlk" from the amdgpu-vulkan-switcher package) ' \
	"$OGL_STATE" amdogl-pro  'AMD™ Proprietary OpenGL implementation (this can be invoked by "$ gl_pro" from the amdgpu-opengl-switcher package) ' \
	"$OCL_STATE" amdocl-legacy  'AMD™ Proprietary OpenCL implementation (this can be invoked by "$ cl_pro" from the amdgpu-opencl-switcher package) (USE ROCM INSTEAD, UNLESS SPECIFICALLY NEEDED!) ' \
	--separator="'" --checklist --title='Component install selection' --width 920 --height 450)
	
	echo "'"$COMP_SEC"'" | tee -a /tmp/zenity/nobara-amdgpu-config/components
	
		# Warn users about broken packages
		if [ -s /tmp/zenity/nobara-amdgpu-config/components ]
		then
		zenity --warning --text="Do not interrupt this process ! , this might take while please be patient !"
	
		# Danger SUDO
	
		pkexec env PATH=$PATH DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY /etc/nobara/scripts/amdgpu-build.sh
		else
		rm -r /tmp/zenity/nobara-amdgpu-config
		echo "Stop installation!" && zenity --warning --text="No drivers selected!" && exit
		fi
	else
	rm -r /tmp/zenity/nobara-amdgpu-config
	echo "Stop installation!" && zenity --warning --text="Not installing additional drivers!" && exit
	fi
	
	
	else 
	rm -r /tmp/zenity/nobara-amdgpu-config
	zenity --warning --text="Not installing additional drivers!"
	fi
else 
	echo "ending script!"
fi

