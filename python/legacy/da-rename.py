import os
import sys
import re

def da_rename(path):
    filename_old = path

    filename, fileext = os.path.splitext(path)

    filename = str(filename.split("-")[0])
    filename = str(filename.replace("___", " - ").replace("_", " ").title().replace("By", "by")) + fileext
    print(filename_old, "->", filename)
    os.rename(filename_old, filename)

if __name__ == "__main__":

    da_rename(sys.argv[1])
