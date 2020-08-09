# frozen_string_literal: true

# Copyright (c) 2018-2020 Robert Haines.
#
# Licensed under the BSD License. See LICENCE for details.

require 'ffi/openmpt'

require_relative 'audio'
require_relative 'audio/portaudio'
require_relative 'ui/root'

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
