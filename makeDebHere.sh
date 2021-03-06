#!/bin/sh

# Copyright 2010 Boris Daeppen <boris_daeppen@bluewin.ch>
# 
# This file is part of NaYaBoh.
# 
# NaYaBoh is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# NaYaBoh is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with NaYaBoh.  If not, see <http://www.gnu.org/licenses/>.

##################
# START BUILDING #
##################

# remove old packages
rm nayaboh*.deb 2> /dev/null

#################
# BUILD NAYABOH #
#################

echo 'START NAYABOH PACKAGE'

# pack manpage
mkdir -p debian/usr/share/man/man1
cp documentation/manpage/nayaboh.1 debian/usr/share/man/man1/
cp documentation/manpage/nayaboh_benchmark.1 debian/usr/share/man/man1/
cp documentation/manpage/nayaboh_connections.1 debian/usr/share/man/man1/
cp documentation/manpage/nayaboh_firewall.1 debian/usr/share/man/man1/
cp documentation/manpage/nayaboh_ipconfig.1 debian/usr/share/man/man1/
cp documentation/manpage/nayaboh_installreport.1 debian/usr/share/man/man1/
cp documentation/manpage/nayaboh_proxylog.1 debian/usr/share/man/man1/
cp documentation/manpage/nayaboh_loadconfig.1 debian/usr/share/man/man1/
gzip --best debian/usr/share/man/man1/nayaboh*.1

#pack changelog
cp changelog debian/usr/share/doc/nayaboh/
cp changelog.Debian debian/usr/share/doc/nayaboh/
gzip --best debian/usr/share/doc/nayaboh/changelog
gzip --best debian/usr/share/doc/nayaboh/changelog.Debian

# update md5sums file of dep-tree
echo -e "\tupdate md5sums file"
rm debian/DEBIAN/md5sums
for i in $( find ./debian -path ./debian/DEBIAN -prune -o -type f -print)
do
    md5sum $i | sed -e "s/\.\/debian\///g" >> debian/DEBIAN/md5sums
done

# renew the size information
sed -i '/Installed-Size/ d' debian/DEBIAN/control # delete
echo "Installed-Size: $(du -s --exclude DEBIAN debian/ | cut -f1)" >> debian/DEBIAN/control

# create deb package
echo -e "\tbuild package"
fakeroot dpkg-deb --build debian \
$( grep Package debian/DEBIAN/control | cut -d" " -f2 )_\
$( grep Version debian/DEBIAN/control | cut -d" " -f2 )_\
$( grep Architecture debian/DEBIAN/control | cut -d" " -f2 )\
.deb

# remove packed things,
# I don't need it in src
rm debian/usr/share/man/man1/nayaboh*.1.gz
rm debian/usr/share/doc/nayaboh/changelog.gz
rm debian/usr/share/doc/nayaboh/changelog.Debian.gz

#####################
# BUILD NAYABOH-GUI #
#####################

echo 'START NAYABOH-GUI PACKAGE'

# pack manpage
mkdir -p debian-gui/usr/share/man/man1
cp documentation/manpage/nayaboh_gui.1 debian-gui/usr/share/man/man1/
gzip --best debian-gui/usr/share/man/man1/nayaboh*.1

#pack changelog
cp changelog debian-gui/usr/share/doc/nayaboh-gui/
cp changelog-gui.Debian debian-gui/usr/share/doc/nayaboh-gui/changelog.Debian
gzip --best debian-gui/usr/share/doc/nayaboh-gui/changelog
gzip --best debian-gui/usr/share/doc/nayaboh-gui/changelog.Debian

# add html-documentation to local folder
cp -r documentation/website debian-gui/usr/share/doc/nayaboh-gui/html

# update md5sums file of dep-tree
echo -e "\tupdate md5sums file"
rm debian-gui/DEBIAN/md5sums
for i in $( find ./debian-gui -path ./debian-gui/DEBIAN -prune -o -type f -print)
do
    md5sum $i | sed -e "s/\.\/debian-gui\///g" >> debian-gui/DEBIAN/md5sums
done

# renew the size information
sed -i '/Installed-Size/ d' debian-gui/DEBIAN/control # delete
echo "Installed-Size: $(du -s --exclude DEBIAN debian-gui/ | cut -f1)" >> debian-gui/DEBIAN/control

# create deb package
echo -e "\tbuild package"
fakeroot dpkg-deb --build debian-gui \
$( grep Package debian-gui/DEBIAN/control | cut -d" " -f2 )_\
$( grep Version debian-gui/DEBIAN/control | cut -d" " -f2 )_\
$( grep Architecture debian-gui/DEBIAN/control | cut -d" " -f2 )\
.deb

# remove packed things,
# I don't need it in src
rm debian-gui/usr/share/man/man1/nayaboh*.1.gz
rm debian-gui/usr/share/doc/nayaboh-gui/changelog.gz
rm debian-gui/usr/share/doc/nayaboh-gui/changelog.Debian.gz
# remove html
rm -r debian-gui/usr/share/doc/nayaboh-gui/html

#####################
# BUILD NAYABOH-DEV #
#####################

echo 'START NAYABOH-DEV PACKAGE'

# pack manpage
mkdir -p debian-dev/usr/share/man/man1
cp documentation/manpage/nayaboh_disturb.1 debian-dev/usr/share/man/man1/
gzip --best debian-dev/usr/share/man/man1/nayaboh*.1

#pack changelog
cp changelog debian-dev/usr/share/doc/nayaboh-dev/
cp changelog-dev.Debian debian-dev/usr/share/doc/nayaboh-dev/changelog.Debian
gzip --best debian-dev/usr/share/doc/nayaboh-dev/changelog
gzip --best debian-dev/usr/share/doc/nayaboh-dev/changelog.Debian

# update md5sums file of dep-tree
echo -e "\tupdate md5sums file"
rm debian-dev/DEBIAN/md5sums
for i in $( find ./debian-dev -path ./debian-dev/DEBIAN -prune -o -type f -print)
do
    md5sum $i | sed -e "s/\.\/debian-dev\///g" >> debian-dev/DEBIAN/md5sums
done

# renew the size information
sed -i '/Installed-Size/ d' debian-dev/DEBIAN/control # delete
echo "Installed-Size: $(du -s --exclude DEBIAN debian-dev/ | cut -f1)" >> debian-dev/DEBIAN/control

# create deb package
echo -e "\tbuild package"
fakeroot dpkg-deb --build debian-dev \
$( grep Package debian-dev/DEBIAN/control | cut -d" " -f2 )_\
$( grep Version debian-dev/DEBIAN/control | cut -d" " -f2 )_\
$( grep Architecture debian-dev/DEBIAN/control | cut -d" " -f2 )\
.deb

# remove packed things,
# I don't need it in src
rm debian-dev/usr/share/man/man1/nayaboh*.1.gz
rm debian-dev/usr/share/doc/nayaboh-dev/changelog.gz
rm debian-dev/usr/share/doc/nayaboh-dev/changelog.Debian.gz

echo 'DONE'
echo "don't forget to check the packages with lintian!"

