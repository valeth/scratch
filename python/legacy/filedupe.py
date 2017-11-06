import hashlib
import binascii
import argparse
from multiprocessing import Process, Manager, Lock
from os import walk, path


checksums = dict()


def findfiles(findroot):
    """get all files in findroot with absolute path"""

    files = list()

    for (dirpath, _, filenames) in walk(findroot):
        for f in filenames:
            files.append(path.abspath(path.join(dirpath, f)))

    return files


class FileDupe(object):
    def __init__(self, path):
        self.maxjobs = 7
        self.manager = Manager()
        self.lock = Lock()

        self.filenames = findfiles(path)
        self.checksums = self.manager.dict()
        self.duplicates = dict()

        self.get_duplicates()

    def gen_sha256sums(self, filenames, checksums, lock):
        "generate a sha256 checksums for a list of files"

        for f in filenames:
            fh = open(f, "rb")

            sha256sum = hashlib.sha256()

            while True:
                data = fh.read(2 ** 20)

                if not data:
                    break

                sha256sum.update(data)

            checksum = binascii.hexlify(sha256sum.digest())

            with lock:
                if checksum in checksums.keys():
                    checksums[checksum] += [f]
                else:
                    checksums[checksum] = [f]

            fh.close()

    def partition(self, files):
        n = int(len(files) / self.maxjobs)
        if n < 1:
            n = 1

        for i in range(0, len(files), int(n)):
            yield files[i:i+n]

    def get_duplicates(self):
        partitioned_filelist = list(self.partition(self.filenames))

        procs = [Process(target = self.gen_sha256sums, args = (f, self.checksums, self.lock)) for f in partitioned_filelist]

        for p in procs:
            p.start()

        for p in procs:
            p.join() 
            print(p)

        for k, v in self.checksums.items():
            if len(v) >= 2:
                self.duplicates[k] = v

def test(path):
    filedupes = FileDupe(path)

    for v in filedupes.duplicates.values():
        print(v)

    print("{:} duplicate file(s) found".format(len(filedupes.duplicates.keys())))


if __name__ == "__main__":
    argparser = argparse.ArgumentParser()
    argparser.add_argument("-t", "--test", help = "test function", type = str)
    args = argparser.parse_args()

    if args.test:
        test(args.test)
