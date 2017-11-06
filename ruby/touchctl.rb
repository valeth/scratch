#!/usr/bin/env ruby

require 'childprocess'

# Allows enabling and disabling of touch devices
module Dev
  DEVICES = {
    synaptics: 'SynPS/2 Synaptics TouchPad',
    wacom:     'Wacom BambooPT 2FG 4x5 Finger'
  }.freeze

  ACTIONS = %i[enabled? enable disable toggle].freeze

  module_function

  def xinput(*args)
    r, w = IO.pipe
    process = ChildProcess.build('xinput', *args).tap do |p|
      p.io.stdout = w
      p.io.stderr = w
      p.start
    end

    process.wait
    w.close
    [process.exit_code.zero?, r.read]
  end

  def device(devname)
    DEVICES[devname.to_sym]
  end

  def set(devname, state)
    success, _out = xinput('set-prop', device(devname), 'Device Enabled', state.to_s)
    success
  end

  # actions
  def enabled?(devname)
    _success, out = xinput('list-props', device(devname))
    /Device Enabled.*(?<en>\d)/ =~ out
    en == '1'
  end

  def enable(devname)
    set(devname, 1)
  end

  def disable(devname)
    set(devname, 0)
  end

  def toggle(devname)
    case enabled?(devname)
    when true  then disable(devname)
    when false then enable(devname)
    end
  end
end

COMMANDS = {
  quit:    -> { exit(0) },
  help:    -> { help },
  actions: -> { help_actions },
  devices: -> { help_devices }
}.freeze

def help
  print "Usage:\n\t<device|command> <action>\n\nCommands:\n"
  COMMANDS.each { |k, _| print "\t#{k}\n" }
end

def help_actions
  puts 'Actions:'
  Dev::ACTIONS.each { |e| print "\t#{e}\n" }
end

def help_devices
  puts 'Devices:'
  Dev::DEVICES.each { |k, v| print "\t#{k}:   #{v}\n" }
end

def prompt
  print '> '
  exit(0) unless (choice = $stdin.gets)
  choice.chomp.split.map(&:to_sym)
end

def main
  choice = prompt

  if COMMANDS.keys.include? choice.first
    COMMANDS[choice.first].call
  elsif Dev::DEVICES.keys.include? choice.first
    if Dev::ACTIONS.include? choice.last
      print "<(#{choice.join(' ')})  #{Dev.send(choice.last, choice.first)}\n"
    end
  else
    puts 'invalid input'
    puts 'enter <help> to see available commands'
  end
end

loop { main } if $PROGRAM_NAME == __FILE__
