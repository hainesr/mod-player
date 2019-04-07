# frozen_string_literal: true

# Copyright (c) 2018, 2019 Robert Haines.
#
# Licensed under the BSD License. See LICENCE for details.

require 'optparse'

require 'ffi/openmpt'

require 'mod_player/version'
require 'mod_player/audio'
require 'mod_player/audio/portaudio'
require 'mod_player/ui/root'

module ModPlayer
  class Player

    def initialize(options)
      init_mod(options)
      init_audio
      init_ui
    end

    def stop
      @buffer.free
      @audio.stop
      @ui.close
      @mod.close
    end

    def play
      loop do
        if @ui.paused?
          sleep(1)
          @ui.listen
          next
        end

        can_write = @audio.write_available

        next unless can_write.positive?

        has_read = @mod.read_interleaved_float_stereo(can_write, @buffer)

        break unless has_read.positive?

        @audio.write(@buffer, has_read)
        @ui.listen
      end
    end

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

    private

    def init_mod(options)
      @mod = ::FFI::OpenMPT::Module.new(options[:file])
      @mod.repeat_count = options[:repeat]
    end

    def init_audio
      @audio = ModPlayer::PortAudio.new
      @audio.start

      buffer_max_frames = @audio.write_available * 2
      @buffer = ::FFI::MemoryPointer.new(:float,
                                         buffer_max_frames * @audio.channels)
    end

    def init_ui
      @ui = ModPlayer::UI::Root.new(@mod)
      @ui.open
      @ui.draw
    end
  end
end
