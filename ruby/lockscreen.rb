#!/usr/bin/env ruby

require "dbus" 

bus = DBus.session_bus
service   = bus["org.freedesktop.ScreenSaver"]
object    = service["/org/freedesktop/ScreenSaver"]
interface = object["org.freedesktop.ScreenSaver"]
interface.Lock
