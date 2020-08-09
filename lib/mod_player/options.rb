# frozen_string_literal: true

# Copyright (c) 2020 Robert Haines.
#
# Licensed under the BSD License. See LICENCE for details.

require 'optparse'

require_relative 'version'

module ModPlayer
  class Options
    DEFAULTS = {
      repeat: 0
    }.freeze

    def self.read_opts(args)
      options = {}

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

      DEFAULTS.merge(options)
    end
  end
end
