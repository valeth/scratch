import dbus

def dbus_notify(app_name = "", replaces_id = 0, app_icon = "", summary = "", body = "", actions = "", hints = "", timeout = 0):
    notify_obj = dbus.SessionBus().get_object("org.freedesktop.Notifications", "/org/freedesktop/Notifications")
    notify_if = dbus.Interface(notify_obj, "org.freedesktop.Notifications")
    notify_if.Notify(app_name, replaces_id, app_icon, summary, body, actions, hints, timeout)


if __name__ == "__main__":
    dbus_notify(app_name = "test", app_icon = "folder", summary = "dbus notification with python", body = "<b>Hello World</b>")
