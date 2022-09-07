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
	export ENT1_0=$AMF_STATE
	export ENT1_1=amdamf-runtime-pro
	export ENT1_2="AMD™ 'Advanced Media Framework' can be used for H265/H264 encoding & decoding"
	fi
	#
	if [[ "$VLKPRO_STATE" == TRUE ]]; then
	export ENT2_0=$VLKPRO_STATE
	export ENT2_1=amdvlk-pro
	export ENT2_2="AMD™ Proprietary Vulkan implementation can be used for HW ray-tracing & and is needed for AMF"
	fi
	#
	if [[ "$VLKLEGACY_STATE" == TRUE ]]; then
	export ENT3_0="$VLKLEGACY_STATE"
	export ENT3_1='amdvlk-pro-legacy'
	export ENT3_2="AMD™ Pre 21.50 Proprietary Vulkan implementation can be used for HW ray-tracing & and is needed for AMF"
	fi
	#
	if [[ "$VLKOPEN_STATE" == TRUE ]]; then
	export  ENT4_0="$VLKOPEN_STATE"
	export  ENT4_1='amdvlk-open'
	export  ENT4_2="AMD™ 1st party Vulkan implementation"
	fi
	#
	if [[ "$OGL_STATE" == TRUE ]]; then
	export  ENT5_0="$OGL_STATE"
	export  ENT5_1='amdogl-pro'
	export  ENT5_2="AMD™ Proprietary OpenGL implementation"
	fi
	#
	if [[ "$OCL_STATE" == TRUE ]]; then
	export  ENT6_0="$OCL_STATE"
	export  ENT6_1='amdocl-legacy'
	export  ENT6_2="AMD™ Proprietary OpenCL implementation"
	fi
	
	zenity "$ENT1_0" "$ENT1_1" "$ENT1_2" "$ENT2_0" "$ENT2_1" "$ENT2_2" "$ENT3_0" "$ENT3_1" "$ENT3_2" "$ENT4_0" "$ENT4_1" "$ENT4_2" "$ENT5_0" "$ENT5_1" "$ENT5_2" "$ENT6_0" "$ENT6_1" "$ENT6_2" --list --column Selection --column Package --column Description \
	--separator=" " --checklist --title='Component install selection' --width 920 --height 450 | tee -a /tmp/zenity/nobara-amdgpu-config/components
	
	sed -i "s|amdvlk-open|amdvlk|g"  /tmp/zenity/nobara-amdgpu-config/components
	export COMPONENTS=$(cat  /tmp/zenity/nobara-amdgpu-config/components) 
	
	pkexec env PATH=$PATH DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY bash -c "dnf remove "$COMPONENTS" \ 
	sudo rm -r /tmp/zenity/nobara-amdgpu-config "
	

