#!/bin/sh

if [[ -z $1  ]]; then
	echo "-------------------------------------"
	echo "Usage: <package-name> <architecture>"
	echo "-------------------------------------"
	echo "You must specify a package name and an architecture."
	echo "Achitecture options are \"32\" for 32 bit and \"64\" for 64 bit"
	echo "-------------------------------------"
	echo "64 bit package names are:"
	ls x86_64/ | sed 's/ /\n/g'
	echo "-------------------------------------"
	echo "32 bit package names are:"
	ls i686/ | sed 's/.i686//g'
	exit 1
fi

# install some build dependencies
sudo dnf -y install mock pykickstart fedpkg libvirt

# turn selinux off if it's enabled
sudo setenforce 0

# make a destination folder for our packages
mkdir -p  /tmp/zenity/nobara-amdgpu-config/fedora-amdgpu-pro/packages

# enter the repository of the package to build:
if [[ "$2" == "32" ]]; then
	BUILDARCH="i386"
	cd  /tmp/zenity/nobara-amdgpu-config/fedora-amdgpu-pro/i686/$1.i686
else
	BUILDARCH="x86_64"
	cd  /tmp/zenity/nobara-amdgpu-config/fedora-amdgpu-pro/x86_64/$1
fi

# create a fedora srpm from the spec sheet

rpmbuild -bs --define "_srcrpmdir $(pwd)" --undefine=_disable_source_fetch *.spec

# build the package
mock -r /etc/mock/fedora-36-$BUILDARCH.cfg --enable-network --rebuild *.src.rpm

# cleanup our source rpm
rm /tmp/zenity/nobara-amdgpu-config/fedora-amdgpu-pro/packages/*.src.rpm

# move the package to our main folder
cd /tmp/zenity/nobara-amdgpu-config/fedora-amdgpu-pro

if [[ "$BUILDARCH" == "i386" ]]; then
	sudo mv /var/lib/mock/fedora-36-i686/result/*.rpm  /tmp/zenity/nobara-amdgpu-config/fedora-amdgpu-pro/packages/
else
	sudo mv /var/lib/mock/fedora-36-$BUILDARCH/result/*.rpm  /tmp/zenity/nobara-amdgpu-config/fedora-amdgpu-pro/packages/
fi

# cleanup our source rpm (again)
rm  /tmp/zenity/nobara-amdgpu-config/fedora-amdgpu-pro/packages/*.src.rpm

# re-enable selinux if needed
sudo setenforce 1


