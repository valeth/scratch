#!/usr/bin/env ruby

require 'open-uri'


links_dir = "#{ENV['XDG_DATA_HOME']}/dyndns/*.yml"
links = Dir[links_dir]

links.each do |f|
    puts "Updating Dynamic DNS for #{File.basename(f, '.yml')}"
    link = File.read(f)
    continue unless link
    response = open(link)
    case response
    when StringIO then puts "Response: #{response.string}"
    when Tempfile then puts "Response: #{response.read}"
    end
end
