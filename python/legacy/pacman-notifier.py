# dependencies:
#   python-dbus: notifications
#   python-xdg:  runtime directory
#   pacman:      package manager commands

import dbus
import sys 
import os
import signal
import time
import subprocess
from xdg import BaseDirectory


class SingletonApp(object):
    def __init__(self):
        self.run_dir = os.path.join(BaseDirectory.get_runtime_dir(), "pacman-notifier")
        self.pid_file = os.path.join(self.run_dir, "pid")
        self.pid = os.getpid()

        self.PIDFileCreate(mode="f")

        for sig in [signal.SIGTERM, signal.SIGINT, signal.SIGHUP, signal.SIGQUIT]:
            signal.signal(sig, self.SigHandler)

    def Quit(self, rc=0):
        self.PIDFileRemove()
        time.sleep(1)
        sys.exit(rc)

    def SigHandler(self, signum = None, frame = None):
        print("\nGot Signal", signum)
        self.Quit(0)

    def PIDFileCreate(self, mode=None):
        if not os.path.isdir(os.path.dirname(self.pid_file)):
            os.makedirs(os.path.dirname(self.pid_file))

        if os.path.exists(self.pid_file):
            try:
                pidfromfile = int(open(self.pid_file).read())
            except IOError:
                return 1
            except ValueError:
                return 2

            if mode == "f":
                try:
                    os.kill(pidfromfile, signal.SIGTERM)
                except OSError:
                    print("Failed to kill process %s\n" % pidfromfile)
            else:
                print("Another instance already running: %d\n" % pidfromfile)
                raise SystemExit

        try:
            open(self.pid_file, "w").write(str(self.pid))
        except IOError:
            return 1

    def PIDFileRemove(self):
        try:
            pidfromfile = int(open(self.pid_file).read())
        except IOError:
            return 1
        except ValueError:
            return 2
        if pidfromfile == self.pid:
            try:
                os.remove(self.pid_file)
            except OSError:
                print("could not remove pid file (%s)" % self.pid_file)
                return os.errno

    def DBusNotify(self, app="", icon="", title="", body="", replace=0, act_list="", hints="", timeout=5000):
        connection = "org.freedesktop.Notifications"
        path       = "/org/freedesktop/Notifications"
        interface  = "org.freedesktop.Notifications"
        obj = dbus.SessionBus().get_object(connection, path)
        notify = dbus.Interface(obj, interface)
        notify.Notify(app, replace, icon, title, body, act_list, hints, timeout)
        # obj = dbus.SessionBus().get_object(connection, path)
        # notify = dbus.Interface(obj, interface)
        # notify.Notify(app, replace, icon, title, body, act_list, hints, timeout)

class PacmanNotifier(SingletonApp):
    def __init__(self):
        SingletonApp.__init__(self)
        self.pacman_db_lock = "/var/lib/pacman/db.lck"

    def Updates(self):
        updates = 0

        print("running pacman -Qqu")
        proc = subprocess.Popen(["pacman", "-Qqu"], stdout=subprocess.PIPE)
        proc.wait()

        for line in proc.stdout.readlines():
            updates += 1

        return updates

    def Notify(self, interval=10):
        updates_old = 0
        updates = 0
        msg = ""

        while True:
            if not os.path.exists(self.pacman_db_lock):
                print("checking for updates...")
                updates = self.Updates()
                if (updates != 0) and (updates_old != updates):
                    msg = str(updates) + " updates are available"
                    self.DBusNotify("Pacman", "system-software-update", "Updates Available", msg)
                    print("%s updates available" % updates)
                    updates_old = updates
                else:
                    print("no new updates")

            time.sleep(interval)


def main():
    app = PacmanNotifier()
    app.Notify(3600)
    app.Quit()

if __name__ == "__main__":
    main()
