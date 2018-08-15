#! /bin/sh
# /etc/init.d/jetty
#
# Script to launch run_jetty from CW_Tools.
#
# Installation:
# 1. Copy this script to /etc/init.d/jetty
# 2. Set permissions:
#    chmod 755 /etc/init.d/jetty
# 3. Install this startup script:
#    update-rc.d jetty defaults
# 4. Create a jetty user:
#    useradd jetty
# 5. Extract CW_Tools to directory /home/jetty
# 6. Change the home directory to the cgi-bin location:
#    usermod -d /home/jetty/CW_Tools/tools/jetty
#    Note: This is required because cannot 'cd' from sudo.
#    Note: This script will use the .bash_profile file in
#          the directory /home/jetty/CW_Tools/tools/jetty
# 7. Install Java:
#    apt-get update
#    apt-get install default-jre
#    apt-get install default-jdk
# 8. To manually start|stop Jetty:
#    service jetty start|stop|status

case "$1" in
  start)
    echo "Starting Jetty from CW_Tools..."
    sudo -u jetty -i "run_jetty"
    ;;
  stop)
    echo "Not possible to stop Jetty, sorry."
    ;;
  *)
    echo "Usage: /etc/init.d/jetty {start|stop}"
    exit 1
    ;;
esac
exit 0
