# frozen_string_literal: true

# Copyright (c) 2018-2020 Robert Haines.
#
# Licensed under the BSD License. See LICENCE for details.

require 'ffi'

module ModPlayer
  class Audio
    attr_reader :stream
    attr_reader :channels
    attr_reader :sample_rate
    attr_reader :sample_format

    def initialize(channels, sample_rate, sample_format)
      @stream = ::FFI::Buffer.new(:pointer)
      @channels = channels
      @sample_rate = sample_rate
      @sample_format = sample_format
      @frames = nil
      @flags = nil
    end

    def read_available
      0
    end

    def write_available
      0
    end

    def read
      nil
    end

    def write(_buffer, _size)
      nil
    end

    private

    def input_params
      nil
    end

    def output_params
      nil
    end
  end
end
