import binascii
import sys

def crc32digest(path):
    data = open(path, "rb").read()
    buffer = (binascii.crc32(data) & 0xFFFFFFFF)
    return "{:08X}".format(buffer)

if __name__ == "__main__":
    if len(sys.argv) > 1:
        print(crc32digest(sys.argv[1]))
