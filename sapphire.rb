# Bot Setup + Connect
#-----------------------
require 'bundler/setup'
require 'discordrb'
require 'time_diff'
require_relative 'config.rb'

module Bot
  CONFIG = Config.new('config.yaml')

  bot = Discordrb::Commands::CommandBot.new token: CONFIG.bot_key, client_id: CONFIG.bot_id, prefix: CONFIG.prefix
  
  module DiscordCommands; end
  Dir['modules/*.rb'].each { |mod| load mod }
  DiscordCommands.constants.each do |mod|
    bot.include! DiscordCommands.const_get mod
  end

  # Buckets
  #-----------------------
  bot.bucket :ping, limit: 1, time_span: 60
  bot.bucket :invite, limit: 1, time_span: 240

  # Varible Declarations
  #-----------------------
  ping_desc = 'Alive check for the bot'
  invite_desc = 'Invite url to add the bot to another server'
  roll_desc = 'Rolls between 1 and the number specified, or both numbers specified'
  uptime_desc = 'Prints the bots current uptime'
  tada_desc = 'Celebrates!!!'
  roll_usage = '.roll <max> `or` .roll <min> <max>'

  # Commands
  #-----------------------
  bot.command(:ping, bucket: :ping, description: ping_desc) do |event|
    "Pong o/ #{event.user.name}!"
  end

  bot.command(:invite, bucket: :invite, description: invite_desc) do |_event|
    "Invite me to any server with #{bot.invite_url}"
  end

  bot.command(:eval, help_available: false) do |event, *code|
    break unless event.user.id == CONFIG.owner
    begin
      eval code.join(' ')
    rescue => e
      "It didn't work :cry: sorry.... ```#{e}```"
    end
  end

  bot.command(:restart, help_available: false) do |event|
    if event.user.id == CONFIG.owner
      event.respond 'Restarting Sir'
      bot.stop
    end
  end

  bot.command(:game, help_available: false) do |event, *game|
    bot.game = game.join(' ') if event.user.id == CONFIG.owner
  end

  bot.command(:setname, help_available: false) do |event, name|
    bot.profile.username = name if event.user.id == CONFIG.owner
  end

  bot.command(:setavatar, help_available: false) do |event, url|
    if event.user.id == CONFIG.owner
      open(url) { |pic| bot.profile.avatar = pic }
    end
  end

  bot.command(:tada, description: tada_desc) do |_event|
    ':tada::tada::tada::tada::tada:'
  end

  bot.command(:clean, help_available: false) do |event, num|
    event.channel.prune(num.to_i + 1) if event.user.id == CONFIG.owner
  end

  bot.command(:roll, usage: roll_usage, description: roll_desc) do |_event, min = 1, max|
    rand(min.to_i..max.to_i)
  end

  bot.command(:uptime, description: uptime_desc) do |_event|
    uptime = Time.diff(Time.now, START_TIME)
    'Uptime: '\
    "`#{uptime[:day]}days,"\
    " #{uptime[:hour]}hours &"\
    " #{uptime[:minute]}min`"
  end

  # Ready event
  bot.ready do
    START_TIME = Time.now
  end

  bot.run
end
