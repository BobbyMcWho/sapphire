module Bot
  module DiscordCommands
    module React
      extend Discordrb::Commands::CommandContainer
      extend Discordrb::EventContainer

      poll_desc = 'Does a poll that ends after 2min or the set time, can have up to 5 options seperated with a \'-\''
      poll_usage = "#{CONFIG.prefix}poll 20m <option 1> - <option 2>` Time is optional (from 1m to 60m, don't forget the 'm'), Default = 2m`"

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

      command :poll, help_available: true, description: poll_desc, usage: poll_usage, min_args: 1 do |event, *message|
        reactions = %w(🇦 🇧 🇨 🇩 🇪)
        time = '2m'
        next event.respond 'I can only count to 60m :sweat: sorry' unless message[0].strip =~ /^[1-5]\dm|^60m|^\dm/i
        time = message.shift if message[0].strip =~ /^[1-5]\dm|^60m|^\dm/i
        message = message.join(' ')
        options = message.split('-')
        next event.respond 'I can only count up to 5 options :stuck_out_tongue_closed_eyes:' if options.length > 5
        next event.respond 'I need at least one option :thinking:' if options.empty?
        eachoption = options.map.with_index { |x, i| "#{reactions[i]}. #{x.strip.capitalize}" }
        output = eachoption.join("\n")
        poll = event.respond "Starting poll for: (Expires in: #{time})\n#{output}"
        reactions[0...options.length].each do |r|
          poll.react r
        end
        time = time.to_i * 60
        while time > 0
          sleep 30
          time -= 30
          poll.edit "Starting poll for: (Remaining time: #{time.to_f / 60}m)\n#{output}"
        end
        values = event.channel.message(poll.id).reactions.values
        winning_score = values.collect(&:count).max
        winners = values.select { |r| r.count == winning_score if reactions.include? r.name }
        result = ''
        result << 'Options: '
        reactions[0...options.length].each_with_index do |x, i|
          result << "#{x} = `#{options[i].strip.capitalize}`  "
        end
        result << "\n"
        result << 'Winner(s):'
        winners.each do |x|
          result << " #{x.name} with #{x.count - 1} vote(s)"
        end
        # reactions[0...options.length].each_with_index do |x, i|
        # result << "#{x} `#{options[i].strip.capitalize}` had #{event.channel.message(poll.id).reactions[x].count} vote(s)  "
        # end
        # result << "\n"
        event.respond result
      end
    end
  end
end
