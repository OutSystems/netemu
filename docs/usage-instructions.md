Usage Instructions for the *netem* Raspberry Pi device
=============================================================

Booting the device
------------------

Use an Ethernet cable to connect the device to a network where it can acquire
an IP address dyncamically (through DHCP).
If you only have Wi-Fi, you can use a laptop with an ethernet port and have it
to share it's Wi-Fi internet through the ethernet.

Connect the power adapter to the device.

Connecting through the device
-----------------------------

In order to get the effects of network emulation, you need to connect through
the device. Search for a wireless network named *NETEMU-*n and connect to it.

To configure the network conditions, use a device connected to the NETEMU wifi
and access `http://netemux:3000` (if you can't connect to `netemux` you may try
the address `10.201.0.1:3000` instead).

