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

wget http://download.serviio.org/releases/serviio-1.6-linux.tar.gz && tar xzf serviio-1.6-linux.tar.gz && mv serviio-1.6 /usr/local/serviio

useradd -s /usr/sbin/nologin -d /usr/bin/serviio -r -M -U serviio

chown -R serviio:serviio /usr/bin/serviio

nano /etc/init.d/serviio

    #!/bin/bash
    #
    #########################################################
    #- Daemon script for Serviio media server
    #- By Ian Laird; converted for Debian by Jacob Lundbergand edited by Jopie
    #- /etc/init.d/serviio
    #########################################################
    #
    ### BEGIN INIT INFO
    # Provides:          serviio
    # Required-Start:    $local_fs $remote_fs $network $syslog
    # Required-Stop:     $local_fs $remote_fs $network $syslog
    # Default-Start:     2 3 4 5
    # Default-Stop:      0 1 6
    # X-Interactive:     true
    # Short-Description: Start/stop serviio media server
    # Description:       The Serviio media server makes your media available to
    #                    all kinds of networked devices.
    ### END INIT INFO
     
     
    . /lib/lsb/init-functions
     
    if [ -f /etc/default/rcS ]; then
            . /etc/default/rcS
    fi
     
     
    DAEMON_STOP=" -stop"
    NAME="$(basename $0)"
    PIDFILE="/var/run/serviiod.pid"
    TIMEOUT=10
     
    if [ -f /etc/default/serviio ]; then
            . /etc/default/serviio
    fi
     
    [ -x "$DAEMON" ] || exit 0
     
     
    running() {
            if [ "x$1" == "x" ]; then
                    echo 0
                    return 1
            fi
     
            PS=$(ps h -p $(echo $1 | sed -r 's/[\t \n]+/ -p /') | wc -l)
            echo $PS
     
            if [ $PS -gt 0 ]; then
                    return 0
            else
                    return 1
            fi
    }
     
     
    start() {
            log_daemon_msg "Starting Serviio media server daemon" "$NAME"
            start-stop-daemon --start -q -b -p "$PIDFILE" -m -c "${SERVICE_ACCOUNT}" -x "${DAEMON}"
            log_end_msg $?
    }
     
    stop() {
            log_daemon_msg "Stopping Serviio media server daemon" "$NAME"
            if [ -r "$PIDFILE" ]; then
                    PIDS=$(pstree -p $(<"$PIDFILE") | awk -F'[\(\)]' '/^[A-Za-z0-9]/ { print $2" "$4; }')
                    if running "$PIDS" > /dev/null; then
                            "${DAEMON}" "${DAEMON_STOP}"
                            for PID in $PIDS; do
                                    if running $PID > /dev/null; then
                                            kill -TERM $PID
                                    fi
                            done
                    fi
                    COUNTDOWN=$TIMEOUT
                    while let COUNTDOWN--; do
                            if ! running "$PIDS" > /dev/null; then
                                    break
                            fi
                            if [ $COUNTDOWN -eq 0 ]; then
                                    for PID in $PIDS; do
                                            if running $PID > /dev/null; then
                                                    kill -KILL $PID
                                            fi
                                    done
                            else
                                    echo -n .
                                    sleep 1
                            fi
                    done
           fi
     
            if running "$PIDS" > /dev/null; then
                    log_end_msg 1
            else
                    rm -f "$PIDFILE"
                    log_end_msg $?
            fi
    }
     
    status() {
            echo -n "$NAME should be"
            if [ -r "$PIDFILE" ]; then
                    echo -n " up with primary PID $(<"$PIDFILE")"
                    PIDS=$(pstree -p $(<"$PIDFILE") | awk -F'[\(\)]' '/^[A-Za-z0-9]/ { print $2" "$4; }')
                    RUNNING=$(running "$PIDS")
                    if [[ $RUNNING && $RUNNING -gt 0 ]]; then
                            echo -n " and $RUNNING processes are running."
                    else
                            echo -n " but it is not running."
                    fi
            else
                    echo -n " stopped."
            fi
            echo
    }
     
     
    case "${1:-}" in
            start)
                    start
            ;;
            stop)
                    stop
            ;;
            restart)
                    stop
                    start
            ;;
            status)
                    status
            ;;
            *)
                    log_success_msg "Usage: /etc/init.d/$NAME {start|stop|restart|status}"
                    exit 1
            ;;
    esac

chmod a+rx /etc/init.d/serviio && sudo chown root:root /etc/init.d/serviio && sudo update-rc.d serviio defaults

ln -s /usr/bin/avconv /usr/bin/ffmpeg

# In /opt/serviio/bin/serviio.sh
    JAVA_OPTS="-Djava.net.preferIPv4Stack=true -Djava.awt.headless=true -Dderby.system.home=$SERVIIO_HOME/library -Dserviio.home=$SERVIIO_HOME -Dserviio.socketBuffer=131072"


