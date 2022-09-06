#! /bin/bash

# Detect if an amdgpu is present

if inxi --gpu | grep amdgpu ; then
    echo "amdgpu detected" && export "AMDGPU_DETECTED"=TRUE	
else
    echo "no amdgpu detected on your system"
fi

# Start 

if [[ "$AMDGPU_DETECTED" == TRUE ]]; then
	if zenity --question --text="We have detected modern AMD GPU hardware on your system! , would you like to install some additional drivers for extended functionality?"
	then
	zenity --warning --text="Some of this software is proprietary! , See:  https://www.amd.com/en/support/eula ."
	
	# Clean and make tmp dir
	
	rm -r /tmp/zenity/nobara-amdgpu-config/components
	mkdir -p /tmp/zenity/nobara-amdgpu-config/
	
	# Check for current packages
	
	dnf list --installed | grep amdamf-runtime-pro && export "AMF_STATE"=TRUE || export "AMF_STATE"=FALSE
	dnf list --installed | grep amdvlk-pro && export "VLKPRO_STATE"=TRUE || export "VLKPRO_STATE"=FALSE
	dnf list --installed | grep amdvlk-pro-legacy && export "VLKLEGACY_STATE"=TRUE || export "VLKLEGACY_STATE"=FALSE
	dnf list --installed | grep amdvlk. && export "VLKOPEN_STATE"=TRUE || export "VLKOPEN_STATE"=FALSE
	dnf list --installed | grep amdogl-pro && export "OGL_STATE"=TRUE || export "OGL_STATE"=FALSE
	dnf list --installed | grep amdocl-legacy && export "OCL_STATE"=TRUE || export "OCL_STATE"=FALSE
	
	# Zenity list
	
	zenity --list --column Selection --column Package --column Description \
	"$AMF_STATE" amdamf-runtime-pro 'AMD™ "Advanced Media Framework" can be used for H265/H264 encoding  & decoding' \
	"$VLKPRO_STATE" amdvlk-pro 'AMD™ Proprietary Vulkan implementation can be used for HW ray-tracing & and is needed for AMF (this can be invoked by "$ vk_pro" from the amdgpu-vulkan-switcher package) '  \
	"$VLKLEGACY_STATE" amdvlk-pro-legacy 'AMD™ Pre 21.50 Proprietary Vulkan implementation can be used for HW ray-tracing & and is needed for AMF (this can be invoked by "$ vk_legacy" from the amdgpu-vulkan-switcher package) (only use if the normal amdvlk-pro does not work for you)'  \
	"$VLKOPEN_STATE" amdvlk-open 'AMD™ 1st party Vulkan implementation (this can be invoked by "$ vk_amdvlk" from the amdgpu-vulkan-switcher package) ' \
	"$OGL_STATE" amdogl-pro  'AMD™ Proprietary OpenGL implementation (this can be invoked by "$ gl_pro" from the amdgpu-opengl-switcher package) ' \
	"$OCL_STATE" amdocl-legacy  'AMD™ Proprietary OpenCL implementation (this can be invoked by "$ cl_pro" from the amdgpu-opencl-switcher package) (USE ROCM INSTEAD, UNLESS SPECIFICALLY NEEDED!) ' \
	--checklist --title='Component install selection' --width 920 --height 450 | tee -a /tmp/zenity/nobara-amdgpu-config/components
	
	# Warn users about broken packages
	
	zenity --warning --text="Do not interrupt this process !"
	
	# Danger SUDO
	
	pkexec env PATH=$PATH DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY /etc/nobara/scripts/amdgpu-build.sh
	
	
	else 
	zenity --warning --text="Not installing additional drivers!"
	fi
else 
	echo "ending script!"
fi

