#!/bin/sh

set -e

HOSTNAME=$1
WIFI_NETWORK=$2
WIFI_PSK=$3

usage()
{
	echo "$0 hostname network psk"
}

[ "$HOSTNAME" = "" ] && usage && exit 1
[ "$WIFI_NETWORK" = "" ] && usage && exit 1
[ "$WIFI_PSK" = "" ] && usage && exit 1

mkdir -p ~/tmp
cd ~/tmp
cp /media/sf_fredo/Downloads/2016-05-27-raspbian-jessie-lite.img ./$HOSTNAME.img

ROOT=/home/fredo/tmp/root

mkdir -p $ROOT
mount -v -o offset=70254592 -t auto ./$HOSTNAME.img $ROOT
echo "$HOSTNAME" > $ROOT/etc/hostname
cat $ROOT/etc/hosts | sed "s/raspberrypi/$HOSTNAME/" > $ROOT/etc/hosts2
rm $ROOT/etc/hosts
mv $ROOT/etc/hosts2 $ROOT/etc/hosts

WPA=$ROOT/etc/wpa_supplicant/wpa_supplicant.conf
echo "network={" >> $WPA
echo "    ssid=\"$WIFI_NETWORK\"" >> $WPA
echo "    psk=\"$WIFI_PSK\"" >> $WPA
echo "}" >> $WPA

grep . $ROOT/etc/hostname $ROOT/etc/hosts $ROOT/etc/wpa_supplicant/wpa_supplicant.conf

umount $ROOT

