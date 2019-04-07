# frozen_string_literal: true

# Copyright (c) 2019 Robert Haines.
#
# Licensed under the BSD License. See LICENCE for details.

require 'mod_player/ui/dialog_box'

module ModPlayer
  module UI
    class SamplesList < DialogBox
      def initialize(parent, mod)
        super(parent, SAMPLES_TITLE, 20, 60)

        @mod = mod
      end

      private

      def draw_content
        num_samples = @mod.num_samples
        sample_break = num_samples == 15 ? num_samples : num_samples / 2
        (0..num_samples).each do |i|
          x, y = i > sample_break ? [i - (sample_break - 1), 32] : [i + 2, 2]
          setpos(x, y)
          addstr("#{i}: #{@mod.sample_name(i)}")
        end
      end
    end
  end
end
