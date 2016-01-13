#!/bin/bash
# This script sets up a raspberry pi will do the following:
# - remove all uneccesary packages
# - install homegear
# - install openHAB
# - install a squeezebox client

$devicename="homeautomator"
$squeezeboxname="soundbox2"
# Remove unnecessary packages
echo Remove unnecessary packages
sudo -s
# apt-get remove -y --purge wolfram-engine penguinspuzzle scratch dillo squeak-vm squeak-plugins-scratch sonic-pi idle idle3 netsurf-gtk netsurf-common
# apt-get remove -y --purge gnome-* lxde* lightdm* xserver* desktop-* python* smbclient lxappearance lxinput lxmenu-data lxpanel lxpolkit lxrandr lxsession lxsession-edit lxshortcut lxtask lxterminal leafpad menu menu-xdg xpdf xkb-data xinit xfonts-utils xfonts-encodings xdg-utils xauth xarchiver x11-utils x11-common

wget http://homegear.eu/packages/Release.key && apt-key add Release.key && rm Release.key
if [ -f /etc/apt/sources.list.d/homegear.list ]
then
    echo homegear debian package already exists
else
    echo 'deb http://homegear.eu/packages/Raspbian/ wheezy/' >> /etc/apt/sources.list.d/homegear.list 
fi

if [ -f /etc/apt/sources.list.d/openhab.list ]
then
    echo openHAB debian package already exists
else
    echo 'deb http://repository-openhab.forge.cloudbees.com/release/1.6.2/apt-repo/ /' >> /etc/apt/sources.list.d/openhab.list
fi

apt-get update
apt-get upgrade --assume-yes
apt-get rpi-update
apt-get autoremove -y   
apt-get clean
reboot

sudo -s
echo #######################################
echo # Install homegear
echo #######################################
apt-get -y install homegear --force-yes

echo #######################################
echo # homegear: Pairing the devices
echo #######################################
echo Learn ho to bind the devices at https://www.homegear.eu/index.php/Pairing_HomeMatic_BidCoS_Devices


echo # Install Java
apt-get install oracle-java8-installer


echo #######################################
echo # Install openhab
echo #######################################

apt-get install -y  openhab-runtime --force-yes
apt-get install -y  openhab-addon-action-homematic openhab-addon-binding-homematic openhab-addon-binding-squeezebox openhab-addon-binding-weather openhab-addon-io-squeezeserver openhab-addon-action-squeezebox openhab-addon-action-twitter --force-yes
/etc/init.d/openhab start


echo #######################################
echo # Install squeezebox lite
echo #######################################
echo # Before:
echo # alsamixer (to setup the volume to max)
echo # alsactl store (to store the values)
echo # checl webpage http://unix.stackexchange.com/questions/21089/how-to-use-command-line-to-change-volume
echo # to learn how to do it from commandline

apt-get -y install libflac-dev libfaad2 libmad0  --force-yes
cd /home/pi
mkdir squeezelite
cd squeezelite
wget http://squeezelite-downloads.googlecode.com/git/squeezelite-armv6hf
mv squeezelite-armv6hf /usr/bin
cd /usr/bin 
chmod a+x squeezelite-armv6hf

cd /home/pi/squeezelite
wget http://www.gerrelt.nl/RaspberryPi/squeezelite_settings.sh
mv squeezelite_settings.sh /usr/local/bin
chmod a+x /usr/local/bin/squeezelite_settings.sh
wget http://www.gerrelt.nl/RaspberryPi/squeezelitehf.sh
mv squeezelitehf.sh /etc/init.d/squeezelite
 
cd /etc/init.d
chmod a+x squeezelite
update-rc.d squeezelite defaults

#######################################
# Change the squeezelite_settings.sh
#######################################
# from SL_SOUNDCARD="sysdefault:CARD=ALSA" 
# to   SL_SOUNDCARD="front:CARD=Set,DEV=0"
#######################################
# from #SL_NAME="Framboos"
# to SL_NAME="$squeezeboxname"
sed -i 's/SL_SOUNDCARD="sysdefault:CARD=ALSA"/SL_SOUNDCARD="front:CARD=Set,DEV=0"/g' /usr/local/bin/squeezelite_settings.sh
sed -i 's/#SL_NAME="Framboos"/SL_NAME="$squeezeboxname"/g' /usr/local/bin/squeezelite_settings.sh


echo # now run ./squeezelite start
reboot