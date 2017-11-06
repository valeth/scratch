# Video Metadata Editor


import sys
import os
import tempfile
import subprocess
import shutil


def prompt_edit_tags(filename):
    tags = dict()

    while True:
        print("Tags to edit for file {:s}".format(filename))
        print("[1] Title")
        print("[2] Year")
        print("[0] Done")
        sel = int(input("> "))
        if not sel:
            break

        if sel == 1:
            tags["title"] = input("Title: ")
        elif sel == 2:
            tags["year"] = input("Year: ")

    return tags


def write_tags(filename, tags):
    if not tags:
        return

    cmdline = [ "ffmpeg" ]

    tmp_fh = tempfile.TemporaryDirectory()
    o_file = os.path.join(tmp_fh.name, os.path.basename(filename))
    i_file = os.path.abspath(filename)

    cmdline += [ "-i", i_file,
                 "-codec", "copy" ]

    for k, v in tags.items():
        cmdline += [ "-metadata", str(k) + "=" + str(v) ]

    cmdline += [ o_file ]

    proc = subprocess.Popen(cmdline, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    proc.wait()
    
    os.rename(i_file, i_file + ".bak")
    shutil.copyfile(o_file, i_file)


def main(argv):
    for arg in argv[1:]:
        tags = prompt_edit_tags(arg)
        write_tags(arg, tags)
        

if __name__ == "__main__":
    if len(sys.argv) < 2:
        raise SystemExit

    main(sys.argv)
