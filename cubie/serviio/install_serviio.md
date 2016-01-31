# Install Webmin

echo "deb http://download.webmin.com/download/repository sarge contrib" > /etc/apt/sources.list

wget http://www.webmin.com/jcameron-key.asc

apt-key add jcameron-key.asc

apt-get update

apt-get install webmin

# Now install Java 8 (pre-requisite for serviio)

echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" > /etc/apt/sources.list.d/webupd8team-java.list

echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" >> /etc/apt/sources.list.d/webupd8team-java.list

apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886

apt-get update

apt-get install oracle-java8-installer

# Install ffmepg and other libs
apt-get install build-essential libmp3lame-dev libvorbis-dev libtheora-dev libspeex-dev yasm pkg-config libfaac-dev libopenjpeg-dev libx264-dev libass-dev

wget http://ffmpeg.org/releases/ffmpeg-2.8.tar.gz

./configure --enable-gpl --enable-postproc --enable-swscale --enable-avfilter --enable-libmp3lame --enable-libvorbis --enable-libtheora --enable-libx264 --enable-libspeex --enable-shared --enable-pthreads --enable-libopenjpeg --enable-libfaac --enable-nonfree --enable-libass
make

make install

# Install samba

apt-get install samba-common samba 

# Install serviio

> Add the serviio user
sudo adduser serviio

> Remember to provide the password here and all the user details

> Only the full name is necessary

> Next is to connect to the cubietruck with the newly created serviio user and password

su - serviio

wget http://download.serviio.org/releases/serviio-1.6-linux.tar.gz && tar xzf serviio-1.6-linux.tar.gz && mv serviio-1.6 /usr/local/serviio

useradd -s /usr/sbin/nologin -d /usr/local/serviio -r -M -U serviio

chown -R serviio:serviio /usr/local/serviio

nano /etc/init.d/serviio


