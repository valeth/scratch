import sys
import subprocess
import re

class device(object):
    def dev_enabled(dev):
        proc = subprocess.Popen(["xinput", "list-props", dev], stdout = subprocess.PIPE, stderr = subprocess.PIPE)
        proc.wait()

        lines = list()
        for line in proc.stdout.readlines():
            if re.search("\s+Device Enabled \([0-9]+\):\s+1", line.decode("utf-8").rstrip("\n")):
                return True

        return False
        
    def dev_on(dev):
        proc = subprocess.Popen(["xinput", "set-prop", dev, "Device Enabled", "1"], stdout = subprocess.PIPE, stderr = subprocess.PIPE)
        proc.wait()

    def dev_off(dev):
        proc = subprocess.Popen(["xinput", "set-prop", dev, "Device Enabled", "0"], stdout = subprocess.PIPE, stderr = subprocess.PIPE)
        proc.wait()

    def dev_toggle(dev):
        if device.dev_enabled(dev):
            device.dev_off(dev)
        else:
            device.dev_on(dev)

def print_help():
    print("Usage:\n\t{:s} synaptics|wacom".format(sys.argv[0]))



def main():
    devicelist = ("SynPS/2 Synaptics TouchPad", "Wacom BambooPT 2FG 4x5 Finger")

    try:
        if sys.argv[1] == "synaptics":
            device.dev_toggle(devicelist[0])
        elif sys.argv[1] == "wacom":
            device.dev_toggle(devicelist[1])
        else:
            print_help()
            raise SystemExit

    except IndexError:
        print_help()
        raise SystemExit

if __name__ == "__main__":
    main()
