#!/bin/sh

tc qdisc del dev eth0 root 2>/dev/null || true
tc qdisc del dev wlan0 root 2>/dev/null || true

if [ "$1" = "wifi" ]; then
    echo "success"
    exit 0;
fi

UPSTREAM_DELAY="100ms"
UPSTREAM_BANDWIDTH="250kbit"
DOWNSTREAM_DELAY="100ms"
DOWNSTREAM_BANDWIDTH="750kbit"

case "$1" in
    4g)
        UPSTREAM_DELAY="20ms"
        DOWNSTREAM_DELAY="$UPSTREAM_DELAY"
        DOWNSTREAM_BANDWIDTH="4Mbit"
        UPSTREAM_BANDWIDTH="3Mbit"
        ;;
    3g)
        UPSTREAM_DELAY="100ms"
        DOWNSTREAM_DELAY="$UPSTREAM_DELAY"
        DOWNSTREAM_BANDWIDTH="750kbit"
        UPSTREAM_BANDWIDTH="250kbit"
        ;;
    2g)
        UPSTREAM_DELAY="200ms 100ms"
        DOWNSTREAM_DELAY="$UPSTREAM_DELAY"
        DOWNSTREAM_BANDWIDTH="250kbit"
        UPSTREAM_BANDWIDTH="50kbit"
        ;;
    gprs)
        UPSTREAM_DELAY="300ms 200ms"
        DOWNSTREAM_DELAY="$UPSTREAM_DELAY"
        DOWNSTREAM_BANDWIDTH="50kbit"
        UPSTREAM_BANDWIDTH="20kbit"
        ;;
    *)
        echo "Unknown usage" >&2
        exit 1
esac



tc qdisc add dev eth0 root handle 1: prio
tc qdisc add dev eth0 parent 1:1 handle 10: prio
tc qdisc add dev eth0 parent 1:2 handle 2: netem delay $UPSTREAM_DELAY
tc qdisc add dev eth0 parent 2:1 handle 20: htb default 1
tc class add dev eth0 parent 20:1 classid 20:1 htb rate $UPSTREAM_BANDWIDTH burst 15k
tc filter add dev eth0 protocol ip parent 1: prio 1 u32 match ip dport 443 0xffff flowid 1:2
tc filter add dev eth0 protocol ip parent 1: prio 1 u32 match ip dport 80 0xffff flowid 1:2



tc qdisc add dev wlan0 root handle 1: prio
tc qdisc add dev wlan0 parent 1:1 handle 10: prio
tc qdisc add dev wlan0 parent 1:2 handle 2: netem delay $DOWNSTREAM_DELAY
tc qdisc add dev wlan0 parent 2:1 handle 20: htb default 1
tc class add dev wlan0 parent 20:1 classid 20:1 htb rate $DOWNSTREAM_BANDWIDTH burst 15k
tc filter add dev eth0 protocol ip parent 1: prio 1 u32 match ip sport 443 0xffff flowid 1:2
tc filter add dev eth0 protocol ip parent 1: prio 1 u32 match ip sport 80 0xffff flowid 1:2

echo "success"
