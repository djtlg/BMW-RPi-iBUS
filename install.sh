#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

echo
echo ===  Installing Necessary Packages  ===
echo
apt-get update
apt-get install -y python3 python3-dbus python3-gi python3-serial python3-paho-mqtt alsa-utils bluez bluez-tools pulseaudio pulseaudio-module-bluetooth ofono
apt autoremove

echo
echo "===  Creating \"bmw\" user if doesnt exist  ==="
echo
id -u bmw &>/dev/null || useradd bmw --groups bluetooth --home /opt/bmw-agent --system

echo
echo "=== Adding \"pulse\" user to \"bluetooth\" group  ==="
echo
usermod -a -G bluetooth pulse

echo
echo "=== Adding \"bmw\" user to \"pulse-access\" group  ==="
echo
usermod -a -G pulse-access bmw

echo
echo "=== Adding \"bmw\" user to \"dialout\" group  ==="
echo
usermod -a -G dialout bmw

echo
echo "=== Adding \"root\" user to \"pulse-access\" group  ==="
echo
usermod -a -G pulse-access root

#TODO Create a user for ofono and make sure bmw is part of it
#edit /etc/dbus/system.d/ofono.conf and add the following
# <!-- allow users of bluetooth group to communicate -->
#  <policy group="bluetooth">
#    <allow send_destination="org.ofono"/>
#  </policy>


echo
echo "===  Copying script files  to \"/opt/bmw-agent\"==="
echo

mkdir -p /opt/bmw-agent
cp *.py /opt/bmw-agent

chown -R bmw:bmw /opt/bmw-agent

echo
echo "===  Copying systemd scripts  ==="
echo
cp ./etc/systemd/system/bmw-agent.service /etc/systemd/system
cp ./etc/systemd/system/pulseaudio.service /etc/systemd/system
cp ./etc/systemd/system/bluetooth.service.d/bluetooth.conf /etc/systemd/system/bluetooth.service.d

echo
echo "===  Reload systemd  ==="
echo
systemctl daemon-reload

echo
echo "===  Make sure services start on startup  ==="
echo
systemctl enable bmw-agent.service
systemctl enable pulseaudio.service

echo
echo "===  Review the output and if no errors restart the device  ==="
echo

systemctl restart dbus
systemctl restart ofono
systemctl restart bluetooth
systemctl restart pulseaudio
systemctl restart bmw-agent
