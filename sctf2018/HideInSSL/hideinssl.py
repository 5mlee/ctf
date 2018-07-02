#!/usr/bin/env python
from pwn import *
from scapy.all import *

def requset(_packet):
    return _packet[TCP].payload.getlayer(Raw).load[0x13:0x2B]

def response(_packet):
    return int(_packet[TCP].payload.getlayer(Raw).load[0]);

jpg_gadget = ""
packets = rdpcap('./sslpacket.pcap') 
f = open("flag_16.jpg", "wb")
log.info("Start")
#log.info("packets size : %d" % len(packets))
for i, packet in enumerate(packets):
    packet_len = len(packet)

    if packet_len == 74 and packet[TCP].flags == 0x02:
        f = open("flag_%s.jpg" % i, "wb")
    elif packet_len >= 246 and packet_len <= 250:
        jpg_gadget = requset(packet)
    elif packet_len == 67:
        if response(packet) == True:
            f.write(jpg_gadget)
    elif packet_len == 270:
        log.info("Wrote it in file.")
        EOF = True
        f.close()

log.info("Done !")
f.close()

