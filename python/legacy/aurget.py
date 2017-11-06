import urllib3 as urllib
import os
import sys
import certifi
import tarfile


def aurget(pkgname):
    base_url = "https://aur.archlinux.org/packages"
    pkgfile  = pkgname + ".tar.gz"
    url      = os.path.join(base_url, pkgname[0:2], pkgname, pkgfile)

    http     = urllib.PoolManager(cert_reqs="CERT_REQUIRED", ca_certs=certifi.where())
    response = http.request("GET", url)
    
    with open(pkgfile, "wb") as out:
        out.write(response.data)

    response.release_conn()

    if not tarfile.is_tarfile(pkgfile):
        os.remove(pkgfile)
        print("removed invalid file {:s}".format(pkgfile))

    opener, mode = tarfile.open, "r:gz"

    f = opener(pkgfile, mode)
    try:
        f.extractall()
    finally:
        f.close()

if __name__ == "__main__":
    try:
        aurget(sys.argv[1])
    except FileNotFoundError:
        print("Package <{:s}> not found.".format(sys.argv[1]))
