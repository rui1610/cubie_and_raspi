# Preparations
sudo apt-get install ffmpeg

sudo apt-get install screen

sudo apt-get install default-jre

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