#!/usr/bin/bash

run_func() {
	# Clean and make tmp dir

	rm -r /tmp/zenity/nobara-amdgpu-config/components
	mkdir -p /tmp/zenity/nobara-amdgpu-config/
	
	export CMD1_RETURN=1
	
	# Check for current packages

	rpm -qa | grep amdamf-pro-runtime && export "AMF_STATE"=TRUE || export "AMF_STATE"=FALSE
	rpm -qa | grep amdvlk-pro-2 && export "VLKPRO_STATE"=TRUE || export "VLKPRO_STATE"=FALSE
	rpm -qa | grep amdvlk-pro-legacy && export "VLKLEGACY_STATE"=TRUE || export "VLKLEGACY_STATE"=FALSE
	rpm -qa | grep amdvlk-2 && export "VLKOPEN_STATE"=TRUE || export "VLKOPEN_STATE"=FALSE
	rpm -qa | grep amdogl-pro && export "OGL_STATE"=TRUE || export "OGL_STATE"=FALSE
	rpm -qa | grep amdocl-legacy && export "OCL_STATE"=TRUE || export "OCL_STATE"=FALSE
	
		if [[ "$AMF_STATE" == TRUE ]]; then
		export ENT1_0=$AMF_STATE
		export ENT1_1=amdamf-pro-runtime
		fi
		#
		if [[ "$VLKPRO_STATE" == TRUE ]]; then
		export ENT2_0=$VLKPRO_STATE
		export ENT2_1=amdvlk-pro
		fi
		#
		if [[ "$VLKLEGACY_STATE" == TRUE ]]; then
		export ENT3_0=$VLKLEGACY_STATE
		export ENT3_1=amdvlk-pro-legacy
		fi
		#
		if [[ "$VLKOPEN_STATE" == TRUE ]]; then
		export  ENT4_0=$VLKOPEN_STATE
		export  ENT4_1=amdvlk
		fi
		#
		if [[ "$OGL_STATE" == TRUE ]]; then
		export  ENT5_0=$OGL_STATE
		export  ENT5_1=amdogl-pro
		fi
		#
		if [[ "$OCL_STATE" == TRUE ]]; then
		export  ENT6_0=$OCL_STATE
		export  ENT6_1=amdocl-legacy
		fi
	
	CMD1() { 
		zenity $( (( "$AMF_STATE" == TRUE )) && echo " "$ENT1_0" "$ENT1_1" " ) \
		$( (( "$VLKPRO_STATE" == TRUE )) && echo " "$ENT2_0" "$ENT2_1" " ) \
		$( (( "$VLKLEGACY_STATE" == TRUE )) && echo " "$ENT3_0" "$ENT3_1" " ) \
		$( (( "$VLKOPEN_STATE" == TRUE )) && echo " "$ENT4_0" "$ENT4_1"  " ) \
		$( (( "$OGL_STATE" == TRUE )) && echo " "$ENT5_0" "$ENT5_1" " ) \
		$( (( "$OCL_STATE" == TRUE )) && echo " "$ENT6_0" "$ENT6_1"  " ) \
		--list --column Selection --column Package \
		--separator=" " --checklist --title='Component removal selection' --width 600 --height 450  | tee -a /tmp/zenity/nobara-amdgpu-config/components
	}
	
	CMD1
	
	if [ -s /tmp/zenity/nobara-amdgpu-config/components ] 
	then
		export CMD1_RETURN=0
	fi
	
	if [[ "$CMD1_RETURN" == 0 ]]
	then
		pkexec env PATH=$PATH DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY bash -c "dnf remove -y $(cat  /tmp/zenity/nobara-amdgpu-config/components) && rpm -e libdrm-pro.x86_64 libdrm-pro.i686 && rm -r /tmp/zenity/nobara-amdgpu-config ||  rm -r /tmp/zenity/nobara-amdgpu-config " && zenity --info --window-icon='nobara amdgpu uninstaller' --text="Removal Complete!"
	else
		zenity --error --text="Failed to remove amdgpu-pro , please try again!."
	fi
}
run_func
