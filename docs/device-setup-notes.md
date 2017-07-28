Device Setup from regular Raspbian distribution
===============================================

# Enable SSH

create a file named ssh in the boot partition (which is FAT, so should be easy  to write into)

# Setup IP forwarding

Add `echo 1 > /proc/sys/net/ipv4/ip_forward` to `/etc/rc.local`
and enable rc.local by doing `chmod a+x /etc/rc.local`

Add forwarding to iptables

    iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

Persist iptables configuration

    apt-get install iptables-persistent

# Setup hostname

With *netemuN* being the name of the device (eg: *netemu3*)
edit `/etc/dhcpcd.conf`
and add line with: `hostname_short netemuN`

    echo netemuN > /etc/hostname

edit `/etc/hosts`
add netemuN to the list of hosts for `127.0.0.1`

# Configure wireless network

Follow the [instructions here][raspberry-ap].
note that the name of the driver is `nl80211` (with `NL` instead of `N1`).

  [raspberry-ap]: https://www.raspberrypi.org/documentation/configuration/wireless/access-point.md
