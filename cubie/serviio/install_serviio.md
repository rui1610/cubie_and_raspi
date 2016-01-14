# Preparations
sudo apt-get install ffmpeg

sudo apt-get install screen

> Now install Java 8 (pre-requisite for serviio)
echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list

echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list

apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886

apt-get update

apt-get install oracle-java8-installer

> Add the serviio user
sudo adduser serviio

> Remember to provide the password here and all the user details

> Only the full name is necessary

# Switch to new user

> Next is to connect to the cubietruck with the newly created serviio user and password

su - serviio

wget http://download.serviio.org/releases/serviio-1.5.2-linux.tar.gz

tar zxvf serviio-1.5.2-linux.tar.gz

cd serviio-1.5.2/bin

./serviio.sh

# Test
>  Serviio should be up and running now!
