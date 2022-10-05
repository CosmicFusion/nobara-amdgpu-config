Name:          nobara-amdgpu-config
Version:       1.4
Release:       1%{?dist}
License:       GPLv2
Group:         System Environment/Libraries
Summary:       GUI Installer for amdgpu-pro stack in fedora / nobara


URL:           https://github.com/CosmicFusion/nobara-amdgpu-config

Source0:        %{name}-%{version}.x86_64.tar.gz

BuildRequires:	wget

Requires:      /usr/bin/bash
Requires:	/usr/bin/rpmbuild
Requires: fedora-packager 
Requires: rpmdevtools
Requires:	mock
Requires:	zenity

%install
tar -xf %{SOURCE0}
mv usr %{buildroot}/
mv etc %{buildroot}/
mkdir -p %{buildroot}/usr/share/licenses/nobara-amdgpu-config
wget https://raw.githubusercontent.com/CosmicFusion/nobara-amdgpu-config/main/LICENSE.md -O %{buildroot}/usr/share/licenses/nobara-amdgpu-config/LICENSE 

%description
GUI Installer for amdgpu-pro stack in fedora / nobara
%files
%attr(0755, root, root) "/etc/nobara/scripts/amdgpu-build.sh"
%attr(0755, root, root) "/etc/nobara/scripts/amdgpu-modify.sh"
%attr(0755, root, root) "/etc/nobara/scripts/amdgpu-remove.sh"
%attr(0755, root, root) "/etc/nobara/scripts/nobara-amdgpu-config.ui"
%attr(0644, root, root) "/etc/nobara/scripts/nobara-amdgpu-config.py"
%attr(0755, root, root) "/usr/bin/nobara-amdgpu-config"
%attr(0644, root, root) "/usr/share/licenses/nobara-amdgpu-config/LICENSE"
