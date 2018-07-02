#!/usr/bin/env python
from pwn import *
import json

addr = "bankrobber.eatpwnnosleep.com"
port = 4567
s = remote(addr, port)

def auth():
    s.recvuntil("API key required : ")
    s.sendline("349b7ec9c6b3caa710b03589aede7a9bcf2c1466307e7f6a3ce3ef1b8c30aa0e")
    s.recv(4096)

def solver():
    f = open("SCTFBank.sol", "r")
    s.send(f.read())
    f.close()

auth()
solver()

s.interactive()
s.close()
