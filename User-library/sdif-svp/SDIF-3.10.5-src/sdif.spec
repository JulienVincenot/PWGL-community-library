# -*-rpm-spec-*-
Name: SDIF
Summary: The SDIF Sound Description Interchange Format IRCAM Library
Version: 3.10.5
Release: 1
Copyright: LGPL
Group: Applications/Multimedia
Source: http://www.ircam.fr/anasyn/sdif/download/SDIF-%{version}-src.tar.gz
BuildRoot: /var/tmp/sdif-%{version}-root
%description
The SDIF Sound Description Interchange Format IRCAM Library
see http://www.ircam.fr/sdif
%prep

%setup -n SDIF-%{version}-src

%build
./configure --prefix=/usr
make

%install
rm -rf $RPM_BUILD_ROOT
make DESTDIR=$RPM_BUILD_ROOT install

%clean
rm -rf $RPM_BUILD_ROOT


%post

%files
%defattr(-, root, root)
/usr/bin/
/usr/lib/libsdif*
/usr/lib/pkgconfig/sdif.pc
/usr/share/SdifTypes.STYP
/usr/include/

%changelog

* Mon Jan 12 2004 Patrice Tisserand <Patrice.Tisserand@ircam.fr> 3.10.5-1
- remove packaging of debug info in standard rpm.
