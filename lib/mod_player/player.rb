# frozen_string_literal: true

# Copyright (c) 2018, 2019 Robert Haines.
#
# Licensed under the BSD License. See LICENCE for details.

require 'optparse'

require 'mod_player/version'
require 'mod_player/audio'
require 'mod_player/audio/portaudio'
require 'mod_player/ui'

module ModPlayer
  class Player

    def self.read_opts(args)
      options = {
        repeat: 0
      }

      opts = OptionParser.new do |opt|
        opt.banner = 'Usage: player [options] MOD'
        opt.separator '  Play a mod/tracker file. [options] can be:'
        opt.on('-r[N]', '--repeat[=N]', 'Repeat the mod N times. ' \
          'Omit N to repeat forever. Default is no repeat.') do |val|
          options[:repeat] = val.nil? ? -1 : val.chomp.to_i
        end

        opt.on_tail('-h', '-?', '--help', 'Show this help message.') do
          puts opts
          exit
        end
        opt.on_tail('-v', '--version', 'Show the version.') do
          puts ModPlayer::VERSION
          exit
        end
      end

      opts.parse! args

      options[:file] = args[0].chomp

      options
    end

  end
end
