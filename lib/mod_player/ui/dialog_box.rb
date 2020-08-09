# frozen_string_literal: true

# Copyright (c) 2019, 2020 Robert Haines.
#
# Licensed under the BSD License. See LICENCE for details.

require 'curses'

module ModPlayer
  module UI
    class DialogBox < Curses::Window
      def initialize(parent, title, height, width)
        y = (Curses.lines - height) / 2
        x = (Curses.cols - width) / 2
        super(height, width, y, x)

        @parent = parent
        @title = title
        @open = false
      end

      def draw
        box('|', '-')

        draw_title
        draw_content
        draw_footer

        refresh
      end

      def toggle
        @open ? @parent.draw : draw
        @open = !@open
      end

      def open?
        @open
      end

      private

      def draw_title
        setpos(0, 0)
        attrset(Curses::A_REVERSE)
        addstr("*** #{@title} ***".center(maxx, ' '))
        attrset(Curses::A_NORMAL)
      end

      def draw_content; end

      def draw_footer; end
    end
  end
end
