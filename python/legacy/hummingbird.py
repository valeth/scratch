import requests
import urllib
import json

class Hummingbird(object):
    def __init__(self, apiver = "v1"):
        self.base_url = "https://hummingbird.me/api/" + apiver + "/"
        self.responses = {
                "sbt":      {"time": 0, "data": dict()},
                "userlib":  {"time": 0, "data": None},
                "userinfo": {"time": 0, "data": str()}
        }

    def request(self, url):
        tmp = []
        response = urllib.request.urlopen(self.base_url + url).readlines()
        for r in response:
            tmp.append(json.loads(r.decode("utf-8")))
        return tmp

    def searchByTitle(self, title):
        url = "/search/anime?query=" + title
        if not title in self.responses["sbt"]["data"].keys():
            print("fetching title info...")
            self.responses["sbt"]["data"][title] = self.request(url)[0]
        return self.responses["sbt"]["data"][title]

    def getUserLibrary(self, username):
        url = "/users/" + username + "/library"
        if not self.responses["userlib"]["data"]:
            print("fetching user library...")
            self.responses["userlib"]["data"] = self.request(url)[0]
        return self.responses["userlib"]["data"]

    def getUserInfo(self, username):
        url = "/users/" + username
        if not self.responses["userinfo"]["data"]:
            print("fetching user info...")
            self.responses["userinfo"]["data"] = self.request(url)[0]
        return self.responses["userinfo"]["data"]


def selectAction(hb, option):
    query = None
    response = None
    if option == "search":
        query = input("HBcli|search> ")
        if query == "back":
            return
        response = hb.searchByTitle(query)
    elif option == "userinfo":
        query = input("HBcli|info> ")
        if query == "back":
            return
        response = hb.getUserInfo(query)
    elif option == "userlib":
        query = input("HBcli|lib> ")
        if query == "back":
            return
        response = hb.getUserLibrary(query)
    else:
        return

    print(json.dumps(response, sort_keys = True, indent = 4))

def userPrompt(hb):
    uinput = None
    while not uinput in ["exit", "quit"]:
        uinput = input("HBcli> ")
        selectAction(hb, uinput)

if __name__ == "__main__":
    userPrompt(Hummingbird())
