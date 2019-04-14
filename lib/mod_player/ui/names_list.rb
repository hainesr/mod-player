# frozen_string_literal: true

# Copyright (c) 2019 Robert Haines.
#
# Licensed under the BSD License. See LICENCE for details.

require 'mod_player/ui/dialog_box'

module ModPlayer
  module UI
    class NamesList < DialogBox
      COLUMN_BREAK = 15

      def initialize(parent, type, base_index = 0)
        super(parent, "#{type}s".capitalize, 20, 60)

        @method = "#{type}_names".to_sym
        @base_index = base_index
      end

      private

      def draw_content
        names = @parent.mod.send(@method)

        names.each_with_index do |name, i|
          y, x = i > COLUMN_BREAK ? [i - (COLUMN_BREAK - 1), 32] : [i + 2, 2]
          setpos(y, x)
          addstr("#{@base_index + i}: #{name}")
        end
      end
    end
  end
end
