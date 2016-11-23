module Bot
  module DiscordCommands
    module React
      extend Discordrb::Commands::CommandContainer
      extend Discordrb::EventContainer

      poll_desc = 'Does a 120s poll, can have up to 5 options seperated with a \'-\''
      poll_usage = "#{CONFIG.prefix}poll <option 1> - <option 2> - <option 3>"

      command(:waifu, help_available: false) do |event|
        event.message.react '🇦'
        event.message.react '🇱'
        event.message.react '🇹'
        event.message.react '🇪'
        event.message.react '🇷'
      end

      command :newtada, help_available: false do |event|
        event.message.react '🎉'
      end

      command :america, help_available: false do |event|
        event.message.react '🇹'
        event.message.react '🇷'
        event.message.react '🇺'
        event.message.react '🇲'
        event.message.react '🇵'
      end

      message(contains: /.{5,}\?$/i) do |event|
        random = rand(1..3)
        event.message.react '✅' if random == 1
        event.message.react '❌' if random == 2
        event.message.react '❓' if random == 3
      end

      command :alter, help_available: false do |event|
        event.message.react '🍕'
      end

      command :poll, help_available: true, description: poll_desc, usage: poll_usage do |event, *message|
        reactions = %w(🇦 🇧 🇨 🇩 🇪)
        message = message.join(' ')
        options = message.split('-')
        length = options.length
        next event.respond 'I can only count up to 5 options :stuck_out_tongue_closed_eyes:' if options.length > 5
        next event.respond 'I need at least one option :thinking:' if options.empty?
        options = options.map.with_index { |x, i| "#{reactions[i]}. #{x.strip.capitalize}" }
        output = options.join("\n")
        poll = event.respond "Starting poll for: (expires in 120s)\n#{output}"
        reactions[0...options.length].each do |r|
          poll.react r
        end
        sleep 5
        result = ''
        reactions[0...options.length].each do |x|
        result << "#{x} had #{event.channel.message(poll.id).reactions[x].count} vote(s)  "
        end
        event.respond result
      end
    end
  end
end
