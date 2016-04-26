#! /bin/sh
# Configure your paths and filenames
SOURCEBINPATH=.
SOURCESESSION=svirfneblin.desktop
SOURCELAUNCHER=svirfneblin.desktop
SOURCEDOC=README.md
DEBFOLDER=svirfneblin-session

DEBVERSION=$(date +%Y%m%d)

TOME="$( cd "$( dirname "$0" )" && pwd )"
cd $TOME

git pull origin master

DEBFOLDERNAME="$TOME/../$DEBFOLDER-$DEBVERSION"
DEBPACKAGENAME=$DEBFOLDER\_$DEBVERSION

rm -rf $DEBFOLDERNAME
# Create your scripts source dir
mkdir $DEBFOLDERNAME

# Copy your script to the source dir
cp $TOME $DEBFOLDERNAME/ -R
cd $DEBFOLDERNAME

pwd

# Create the packaging skeleton (debian/*)
dh_make --indep --createorig 

mkdir -p debian/tmp/usr
cp -R usr debian/tmp/usr

# Remove make calls
grep -v makefile debian/rules > debian/rules.new 
mv debian/rules.new debian/rules 

# debian/install must contain the list of scripts to install 
# as well as the target directory
#echo usr/bin/$SOURCEBIN usr/bin > debian/install 
echo usr/share/applications/$SOURCELAUNCH usr/share/applications >> debian/install 
echo usr/share/xsessions/$SOURCESESSION usr/share/xsessions >> debian/install 
echo usr/share/doc/$DEBFOLDER/$SOURCEDOC usr/share/doc/$DEBFOLDER >> debian/install

echo "Source: $DEBFOLDER
Section: unknown
Priority: optional
Maintainer: dyngar-m <dyngar-m@dyngar.local>
Build-Depends: debhelper (>= 9)
Standards-Version: 3.9.5
Homepage: https://www.github.com/cmotc/svirfneblin-session
#Vcs-Git: https://www.github.com/cmotc/svirfneblin-session
#Vcs-Browser: https://www.github.com/cmotc/svirfneblin-session

Package: $DEBFOLDER
Architecture: all
Depends: lightdm , lighdm-gtk-greeter, awesome (>= 3.4), svirfneblin-panel, svirfneblin-battery-widget, svirfneblin-network-manager, svirfneblin-goblin, svirfneblin-conky-hud \${misc:Depends}
Description: A custom AwesomeWM session designed to give much of the convenience
 of a heavier desktop environment like Gnome3 in a way which gives the user
 deeper control.
" > debian/control

#echo "gsettings set org.gnome.desktop.session session-name awesome-gnome
#dconf write /org/gnome/settings-daemon/plugins/cursor/active false
#gconftool-2 --type bool --set /apps/gnome_settings_daemon/plugins/background/active false
#" > debian/postinst
# Remove the example files
rm debian/*.ex
rm debian/*.EX

# Build the package.
# You  will get a lot of warnings and ../somescripts_0.1-1_i386.deb
debuild -us -uc >> ../log
