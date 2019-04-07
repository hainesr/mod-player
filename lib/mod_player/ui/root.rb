# frozen_string_literal: true

# Copyright (c) 2019 Robert Haines.
#
# Licensed under the BSD License. See LICENCE for details.

require 'curses'

require 'mod_player/ui'
require 'mod_player/ui/help_screen'
require 'mod_player/ui/samples_list'

module ModPlayer
  module UI
    class Root
      include Curses

      def initialize(mod)
        @mod = mod
        @paused = false
      end

      def open
        init_screen
        noecho
        curs_set(0)
        @window = Window.new(lines, cols, 0, 0)
        @window.nodelay = true

        @help = HelpScreen.new(self)
        @samples = SamplesList.new(self, @mod)
      end

      def close
        @window.close
        close_screen
      end

      def listen
        case @window.getch
        when 'h'
          @help.toggle
        when 'p', ' '
          @paused = !@paused
        when 'q', 27 # ESC
          exit
        when 's'
          @samples.toggle
        end
      end

      def draw
        @window.clear

        draw_header
        draw_static_info
        draw_footer

        @window.refresh
      end

      def paused?
        @paused
      end

      private

      def mod_duration
        duration = @mod.duration
        duration_mins = duration.floor / 60
        duration_secs = duration % 60

        [duration_mins, duration_secs]
      end

      def mod_duration_string
        duration = mod_duration

        "#{duration[0]}:#{duration[1].round(3)}"
      end

      def draw_header
        @window.attrset(A_REVERSE)
        @window.setpos(0, 0)
        @window.addstr(HEADER_TEXT.center(cols, ' '))
        @window.attrset(A_NORMAL)
      end

      def draw_static_info
        @window.setpos(2, 0)
        @window.addstr("Title......: #{@mod.title}\n")
        @window.addstr("Duration...: #{mod_duration_string}\n")
        @window.addstr("Type.......: #{@mod.type}\n")
        @window.addstr("Format.....: #{@mod.type_long}\n")
        @window.addstr("Tracker....: #{@mod.tracker}\n\n")
        @window.addstr("Subsongs...: #{@mod.num_subsongs}\n")
        @window.addstr("Channels...: #{@mod.num_channels}\n")
        @window.addstr("Patterns...: #{@mod.num_patterns}\n")
        @window.addstr("Orders.....: #{@mod.num_orders}\n")
        @window.addstr("Samples....: #{@mod.num_samples}\n")
        @window.addstr("Instruments: #{@mod.num_instruments}\n")
      end

      def draw_footer
        @window.setpos(lines - 2, 0)
        @window.addstr(FOOTER_TEXT[0].center(cols))
        @window.attrset(A_REVERSE)
        @window.setpos(lines - 1, 0)
        @window.addstr(FOOTER_TEXT[1].center(cols, ' '))
        @window.attrset(A_NORMAL)
      end
    end
  end
end
