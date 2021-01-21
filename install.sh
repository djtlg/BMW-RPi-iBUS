#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

echo
echo ===  Installing Necessary Packages  ===
echo
apt-get update
apt-get install -y python python-dbus python-gobject-2 python-serial python-paho-mqtt alsa-utils bluez bluez-tools pulseaudio pulseaudio-module-bluetooth
apt autoremove

echo 
echo ===  Creating the user  ===
echo
id -u bmw &>/dev/null || useradd bmw --groups bluetooth --create-home
usermod -a -G bluetooth pulse

echo
echo ===  Copying script files  ===
echo

mkdir -p /opt/bmw-agent
cp *.py /opt/bmw-agent

chown -R bmw:bmw /opt/bmw-agent

echo
echo ===  Copying systemd scripts  ===
echo
cp ./etc/systemd/system/bmw-agent.service /etc/systemd/system
cp ./etc/systemd/system/pulseaudio.service /etc/systemd/system

systemctl daemon-reload
echo
echo ===  Make sure services start on startup  ===
echo
systemctl enable bmw-agent.service
systemctl enable pulseaudio.service

echo
echo "===  Review the output and if no errors restart the device  ==="
echo

