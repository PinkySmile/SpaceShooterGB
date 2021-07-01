#!/usr/bin/python3

import serial
import argparse
import logging
from time import sleep
import re

upload_size = 256

logging.basicConfig(level="INFO")
parser = argparse.ArgumentParser()
parser.add_argument("port", help="example: /dev/ttyUSB0")
parser.add_argument("-b", "--baud", default=57600, help="change baud", type=int)
parser.add_argument("-t", "--timeout", default=1, help="change timeout", type=int)
serializer = logging.getLogger("Serializer")
logger = logging.getLogger("Main")

def readsp(sp):
    while sp.inWaiting() == 0:
        sleep(0.5)
    txt = sp.readline().decode('ascii').rstrip('\r\n')
    serializer.info(txt)
    return txt

def wait_for(txt, sp):
    while True:
        n = readsp(sp)
        if txt == n:
            return n

def main(args):
    with serial.Serial(args.port, args.baud, timeout=None) as sp:
        if not sp.isOpen():
            raise Exception("Port is not open")
        while sp.inWaiting() == 0:
            trash = sp.read_all()  # empty buffer
            sleep(0.5)
        sp.write("2".encode('ascii', 'replace'))
        sleep(1)
        wait_for("END", sp)



main(parser.parse_args())
