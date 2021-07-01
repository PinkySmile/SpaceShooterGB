#!/usr/bin/python3

from sys import stdout, stderr
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
parser.add_argument("-w", "--write", default=None, help="Write instead of reading", type=int)
parser.add_argument("address", help="set the address", type=int)
args = parser.parse_args()
serializer = logging.getLogger("Serializer")


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


with serial.Serial(args.port, args.baud, timeout=None) as sp:
	if not sp.isOpen():
		raise Exception("Port is not open")
	while sp.inWaiting() == 0:
		trash = sp.read_all()  # empty buffer
		sleep(0.5)
	if args.write is None:
		sp.write(b"0" + args.address.to_bytes(4, 'big') + int(0).to_bytes(1, 'little'))
	else:
		sp.write(b"1" + args.address.to_bytes(4, 'big') + args.write.to_bytes(1, 'little'))
	sleep(1)
	wait_for("END", sp)


