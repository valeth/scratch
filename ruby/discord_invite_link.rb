#!/usr/bin/env ruby

bot_id = ARGV.first
abort 'Client ID required' unless bot_id

url = 'https://discordapp.com/oauth2/authorize'
url += "?client_id=#{bot_id}&scope=bot&permissions=0"

puts url
