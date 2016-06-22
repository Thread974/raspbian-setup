#!/bin/sh

set -e

IMAGE=$1
HOSTNAME=$2
WIFI_NETWORK=$3
WIFI_PSK=$4
SSH_PUB_KEY=$5

IMAGEFILE=$IMAGE

offset_ext4()
{
	SECTOR=`sudo fdisk -l $IMAGEFILE | grep img2 | awk '{print $2}'`
	echo "Got sector: $SECTOR"
	OFFSET=`expr "$SECTOR" "*" "512"`
}

usage()
{
	echo "$0 image hostname network psk id_rsa.pub"
}

[ "$HOSTNAME" = "" ] && usage && exit 1
[ "$WIFI_NETWORK" = "" ] && usage && exit 1
[ "$WIFI_PSK" = "" ] && usage && exit 1
[ "$IMAGE" = "" ] && usage && exit 1
[ "$SSH_PUB_KEY" = "" ] && usage && exit 1

cp $IMAGEFILE ./$HOSTNAME.img

ROOT=./root

offset_ext4
echo "Calculated offset: $OFFSET"

mkdir -p $ROOT
mount -v -o offset=$OFFSET -t auto ./$HOSTNAME.img $ROOT

# Hostname
echo "$HOSTNAME" > $ROOT/etc/hostname
cat $ROOT/etc/hosts | sed "s/raspberrypi/$HOSTNAME/" > $ROOT/etc/hosts2
rm $ROOT/etc/hosts
mv $ROOT/etc/hosts2 $ROOT/etc/hosts

# Wifi settings
WPA=$ROOT/etc/wpa_supplicant/wpa_supplicant.conf
echo "network={" >> $WPA
echo "    ssid=\"$WIFI_NETWORK\"" >> $WPA
echo "    psk=\"$WIFI_PSK\"" >> $WPA
echo "}" >> $WPA

# SSH key
mkdir -p $ROOT/home/pi/.ssh
AUTH=$ROOT/home/pi/.ssh/authorized_keys
cp $SSH_PUB_KEY $AUTH
chmod 444 $AUTH
# not working because pi user not exist on linux chown pi  $AUTH ; chgrp pi  $AUTH


# Display result
echo "Result:"
grep . $ROOT/etc/hostname $ROOT/etc/hosts $ROOT/etc/wpa_supplicant/wpa_supplicant.conf $AUTH

# Cleanup
umount $ROOT
rmdir $ROOT

