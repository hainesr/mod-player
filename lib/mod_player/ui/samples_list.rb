# frozen_string_literal: true

# Copyright (c) 2019 Robert Haines.
#
# Licensed under the BSD License. See LICENCE for details.

require 'mod_player/ui/dialog_box'

module ModPlayer
  module UI
    class SamplesList < DialogBox
      COLUMN_BREAK = 15

      def initialize(parent, mod)
        super(parent, SAMPLES_TITLE, 20, 60)

        @mod = mod
      end

      private

      # Samples are typically numbered from 1 when listed, and old
      # school mods really do have 15 or 31 samples, not 16 or 32.
      def draw_content
        sample_names = @mod.sample_names

        sample_names.each_with_index do |name, i|
          y, x = i > COLUMN_BREAK ? [i - (COLUMN_BREAK - 1), 32] : [i + 2, 2]
          setpos(y, x)
          addstr("#{i + 1}: #{name}")
        end
      end
    end
  end
end
