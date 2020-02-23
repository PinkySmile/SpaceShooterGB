import serial
import argparse
import logging
from time import sleep
import re

logging.basicConfig(level="INFO")
parser = argparse.ArgumentParser()
parser.add_argument("port", help="example: /dev/ttyUSB0")
parser.add_argument("rom_file", help="file to upload")
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
    with open(args.rom_file, 'rb') as fd:
        data = fd.read()
    total_len = len(data)
    with serial.Serial(args.port, args.baud, timeout=None) as sp:
        if not sp.isOpen():
            raise Exception("Port is not open")
        while sp.inWaiting() == 0:
            trash = sp.read_all()  # empty buffer
            logging.info(f"Empty buffer: {trash}")
            sleep(0.5)
        logger.info("Sending b\"0\"")
        sp.write(b"0")
        sleep(1)
        logger.info("Wating for \"READY\"...")
        wait_for("READY", sp)
        logger.info(f"Sending {bytes(str(total_len), encoding='ASCII')}")
        sp.write(bytes(str(total_len), encoding="ASCII"))
        sleep(1)
        txt = readsp(sp)
        match = re.match(r"^Size is (\d+)", txt)
        if not match or match[1] != str(total_len):
            raise Exception(f"Arduino returned wrong size, excepted {total_len}, got {match[1]}")
        logger.info("Writing Datas...")
        for i in range(0, total_len, 4096):
            goal = i+4096
            sp.write(data[i:goal])
            while sp.inWaiting() == 0:
                sleep(0.1)
            recv_data = sp.read(4096)
            if recv_data != data[i:goal]:
                raise Exception(f"Data sent and recivied differ, sent:\n{data[i:i+4096]}\n\nrecvieve:{recv_data}")
            logger.info(f"written : {goal}/{total_len}")
            sleep(0.1)

        sleep(0.5)
        logger.info("Sending b\"1\"")
        sp.write(b"1")
        sleep(1)
        wait_for("END", sp)




main(parser.parse_args())