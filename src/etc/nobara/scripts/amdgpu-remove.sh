#! /bin/bash

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

	if [[ "$AMF_STATE" == TRUE ]]; then
	export ENT1='"$AMF_STATE" amdamf-runtime-pro 'AMD™ "Advanced Media Framework" can be used for H265/H264 encoding  & decoding''
	fi
	#
	if [[ "$VLKPRO_STATE" == TRUE ]]; then
	export ENT2='"$VLKPRO_STATE" amdvlk-pro 'AMD™ Proprietary Vulkan implementation can be used for HW ray-tracing & and is needed for AMF '(this can be invoked by "$ vk_pro" from the amdgpu-vulkan-switcher package)'' '
	fi
	#
	if [[ "$VLKLEGACY_STATE" == TRUE ]]; then
	export ENT3=""$VLKLEGACY_STATE" amdvlk-pro-legacy 'AMD™ Pre 21.50 Proprietary Vulkan implementation can be used for HW ray-tracing & and is needed for AMF '(this can be invoked by "$ vk_legacy" from the amdgpu-vulkan-switcher package) (only use if the normal amdvlk-pro does not work for you)''"
	fi
	#
	if [[ "$VLKOPEN_STATE" == TRUE ]]; then
	export  ENT4=""$VLKOPEN_STATE" amdvlk-open 'AMD™ 1st party Vulkan implementation '(this can be invoked by "$ vk_amdvlk" from the amdgpu-vulkan-switcher package)''"
	fi
	#
	if [[ "$OGL_STATE" == TRUE ]]; then
	export  ENT5=""$OGL_STATE" amdogl-pro  'AMD™ Proprietary OpenGL implementation '(this can be invoked by "$ gl_pro" from the amdgpu-opengl-switcher package)''"
	fi
	#
	if [[ "$OCL_STATE" == TRUE ]]; then
	export  ENT6=""$OCL_STATE" amdocl-legacy  'AMD™ Proprietary OpenCL implementation (this can be invoked by "$ cl_pro" from the amdgpu-opencl-switcher package) (USE ROCM INSTEAD, UNLESS SPECIFICALLY NEEDED!)''"
	fi
	
	zenity $ENT1 $ENT2 $ENT3 $ENT4 $ENT5 $ENT6 --list --column Selection --column Package --column Description \
	--separator=" " --checklist --title='Component install selection' --width 920 --height 450 | tee -a /tmp/zenity/nobara-amdgpu-config/components
	
	export COMPONENTS=$(cat  /tmp/zenity/nobara-amdgpu-config/components) 
	
	pkexec env PATH=$PATH DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY bash -c "dnf remove "$COMPONENTS" \ 
	sudo rm -r /tmp/zenity/nobara-amdgpu-config "
	

