#! /bin/bash

if inxi --gpu | grep amdgpu ; then
    echo "amdgpu detected" && export "AMDGPU_DETECTED"=TRUE	
else
    echo "no amdgpu detected on your system"
fi

if [[ "$AMDGPU_DETECTED" == TRUE ]]; then
	if zenity --question --text="We have detected modern AMD GPU hardware on your system! , would you like to install some additional drivers for extended functionality?"
	then
	zenity --warning --text="Some of this software is proprietary! , See:  https://www.amd.com/en/support/eula ."
	rm -r /tmp/"$USER"/nobara-amdgpu-config
	mkdir -p /tmp/"$USER"/nobara-amdgpu-config/
	
	# Check for Installed Packages
	
	dnf list --installed | grep amdamf-runtime-pro && export "AMF_STATE"=TRUE || export "AMF_STATE"=FALSE
	dnf list --installed | grep amdvlk-pro && export "VLKPRO_STATE"=TRUE || export "VLKPRO_STATE"=FALSE
	dnf list --installed | grep amdvlk. && export "VLKOPEN_STATE"=TRUE || export "VLKOPEN_STATE"=FALSE
	dnf list --installed | grep amdogl-pro && export "OGL_STATE"=TRUE || export "OGL_STATE"=FALSE
	dnf list --installed | grep amdocl-pro && export "OCL_STATE"=TRUE || export "OCL_STATE"=FALSE
	
	# Package  Selection
	
	zenity --list --column Selection --column Package --column Description \
	"$AMF_STATE" amdamf-runtime-pro 'AMD™ "Advanced Media Framework" can be used for H265/H264 encoding  & decoding' \
	"$VLKPRO_STATE" amdvlk-pro 'AMD™ Proprietary Vulkan implementation can be used for HW ray-tracing & and is needed for AMF (this can be invoked by "$ vk_pro" from the amdgpu-vulkan-switcher package) '  \
	"$VLKOPEN_STATE" amdvlk-open 'AMD™ 1st party Vulkan implementation (this can be invoked by "$ vk_amdvlk" from the amdgpu-vulkan-switcher package) ' \
	"$OGL_STATE" amdogl-pro  'AMD™ Proprietary OpenGL implementation (this can be invoked by "$ gl_pro" from the amdgpu-opengl-switcher package) ' \
	"$OCL_STATE" amdocl-pro  'AMD™ Proprietary OpenCL implementation (this can be invoked by "$ cl_pro" from the amdgpu-opencl-switcher package) (USE ROCM INSTEAD, UNLESS SPECIFICALLY NEEDED!) ' \
	--checklist --title='Component install/update selection' --width 920 --height 450 | tee -a /tmp/"$USER"/nobara-amdgpu-config/components
	
	# SUDO MODE
	
	# Package installation!
	
	pkexec env PATH=$PATH DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY sudo su root -c \
	''

		
	
	else 
	zenity --warning --text="Not installing additional drivers!"
	fi
else 
	echo "ending script!"
fi	
	

