import urllib3 as urllib
import re


def get_globalip(server = "http://checkip.dyndns.org"):
    searchpat = "[0-9]{1,3}(\.[0-9]{1,3}){3}"

    http     = urllib.PoolManager()
    response = http.request("GET", server)

    ip_addr  = re.search(searchpat, response.data.decode("utf-8"))
    print(ip_addr.group())


if __name__ == "__main__":
    get_globalip()
