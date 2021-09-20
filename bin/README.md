dependency of usb-gadget (only RPi4)
- add dtoverlay=dwc2 into /boot/config.txt
- add modules-load=dwc2 into /boot/cmdline.txt

```sh
> sudo apt install dnsmasq
> echo -e "libcomposite" | sudo tee -a /etc/modules > /dev/null
> echo -e "\n# USB Gadget\ndenyinterfaces usb0" | sudo tee -a /etc/dhcpcd.conf > /dev/null
> echo -e "interface=usb0\ndhcp-range=192.168.55.120,192.168.55.120,255.255.255.0,24h\ndhcp-option=3\nleasefile-ro" | sudo tee /etc/dnsmasq.d/usb > /dev/null
> echo -e "auto usb0\nallow-hotplug usb0\niface usb0 inet static\n  address 192.168.55.1\n  netmask 255.255.255.0" | sudo tee /etc/network/interfaces.d/usb0 > /dev/null
> sudo wget -O /usr/local/bin/usb-gadget http://github.com/planxlabs/Soda/raw/master/bin/usb-gadget
> sudo chmod 755 /usr/local/bin/usb-gadget
> sudo sed '$ d' /etc/rc.local -i
> echo -e "/usr/local/bin/usb-gadget\n\nexit 0" | sodu tee -a /etc/rc.local > /dev/null
```
