As all the HDMI connectors on my TV are already filled, I planned to setup the Raspberry pi's as network only devices.
After flashing Raspbian Lite, the pi booted. Plug ethernet, get address from DHCP and voilà!

...  
...  
Well...  
...  
...  
Not really...  
...

There is a wifi chip in there, let's setup wifi. And now let's add the ssh key so that I don't have to type in my password each time. And having a proper hostname would be nicer.  
...  
...  
...  
And now let's setup the two other devices :)  
  
That take some time, so to ease that process this script generate a raspbian image with all the required provisionning:

    ./raspbian-setup.sh image hostname network psk id_rsa.pub

image is the name of a raspbian image file (I used 2016-05-27-raspbian-jessie-lite.img)  
hostname will be the desired hostname  
network is the SSID of a wifi access point and psk is the key (wpa)  
id_rsa.pub is your ssh public key, you can generate one specific to this purpose with ssh-keygen  

See http://github.com/thread974/raspbian-setup

I used infos from the following site to mount the image:
https://learnaddict.com/2016/02/23/modifying-a-raspberry-pi-raspbian-image-on-linux/

