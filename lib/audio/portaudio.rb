# frozen_string_literal: true

# Copyright (c) 2018 Robert Haines.
#
# Licensed under the BSD License. See LICENCE for details.

require 'audio'
require 'ffi-portaudio'

module ModPlayer
  class PortAudio < Audio

    include FFI::PortAudio

    PA_FORMAT = {
      short: API::Int16,
      float: API::Float32
    }.freeze

    def initialize(channels = 2, sample_rate = 48_000, sample_format = :float)
      super

      @frames = API::FramesPerBufferUnspecified
      @flags = API::NoFlag
    end

    def start
      API.Pa_Initialize
      API.Pa_OpenStream(@stream, input_params, output_params, @sample_rate,
                        @frames, @flags, nil, nil)
      API.Pa_StartStream(@stream.read_pointer)
    end

    def stop
      API.Pa_CloseStream(@stream.read_pointer)
      API.Pa_Terminate
    end

    def write_available
      API.Pa_GetStreamWriteAvailable(@stream.read_pointer)
    end

    def write(buffer, size)
      API.Pa_WriteStream(@stream.read_pointer, buffer, size)
    end

    private

    def output_params
      device = API.Pa_GetDefaultOutputDevice
      device_info = API.Pa_GetDeviceInfo(device)
      params = API::PaStreamParameters.new
      params[:device] = device
      params[:suggestedLatency] = device_info[:defaultHighOutputLatency]
      params[:hostApiSpecificStreamInfo] = nil
      params[:channelCount] = @channels
      params[:sampleFormat] = PA_FORMAT[@sample_format]

      params
    end
  end
end
