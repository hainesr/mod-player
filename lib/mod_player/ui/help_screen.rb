# frozen_string_literal: true

# Copyright (c) 2019 Robert Haines.
#
# Licensed under the BSD License. See LICENCE for details.

require 'mod_player/ui/dialog_box'

module ModPlayer
  module UI
    class HelpScreen < DialogBox
      def initialize(parent)
        super(parent, HELP_TITLE, 14, 60)
      end

      private

      def draw_content
        line = 3
        HELP_TEXT.each do |key, text|
          setpos(line, 2)
          addstr("#{key.rjust(10)} - #{text}")
          line += 1
        end

        setpos(maxy - 2, 2)
        addstr("libopenmpt - #{::FFI::OpenMPT::String.get(:library_version)}")
      end
    end
  end
end
