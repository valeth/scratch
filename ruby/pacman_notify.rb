#!/usr/bin/env ruby

require "dbus" 
require "logger"

Thread.abort_on_exception = true

interval = ARGV.fetch(0) { 3600 }
last_check = 0
update_queue = Queue.new
threads = []
@dbus = DBus.session_bus["org.freedesktop.Notifications"]["/org/freedesktop/Notifications"]["org.freedesktop.Notifications"]
@log = Logger.new(STDOUT)
@log.formatter = proc do |severity, datetime, _progname, message|
  "[#{severity}]  #{datetime}  #{message}\n"
end

def notify(updates)
  message = "#{updates} updates available"
  @log.info { message }
  @dbus.Notify("pacman", 0, "package-x-generic", "Pacman", message, [], [], 3000)
end

threads << Thread.new do
  @log.info { "Checking every #{interval} seconds" }
  loop do
    @log.info { "Checking for updates..." }
    update_queue << `pacman -Qqu`.split("\n").size
    sleep(interval.to_i)
  end
end

threads.last.name = "UpdateCheck"

threads << Thread.new do
  loop do
    updates = update_queue.deq
    if updates != last_check
      last_check = updates
      notify(updates)
    else
      @log.info { "No new updates available" }
    end
  end
end

threads.last.name = "UpdateNotify"

threads.each(&:join)
