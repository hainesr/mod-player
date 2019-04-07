# frozen_string_literal: true

# Copyright (c) 2019 Robert Haines.
#
# Licensed under the BSD License. See LICENCE for details.

require 'curses'

require 'mod_player/ui'

module ModPlayer
  module UI
    class Root
      include Curses

      def initialize(mod)
        @mod = mod

        @help_open = false
        @samples_open = false
        @paused = false
      end

      def open
        init_screen
        noecho
        curs_set(0)
        @window = Window.new(lines, cols, 0, 0)
        @window.nodelay = true

        @help_win = Window.new(lines - 10, cols - 20, 5, 10)
        @samples_win = Window.new(lines - 4, cols - 20, 2, 10)
      end

      def close
        @window.close
        close_screen
      end

      def listen
        case @window.getch
        when 'h'
          help
        when 'p', ' '
          @paused = !@paused
        when 'q', 27 # ESC
          exit
        when 's'
          samples
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

      def samples
        @samples_open ? draw : draw_samples
        @samples_open = !@samples_open
      end

      def draw_samples
        @samples_win.box('|', '-')
        @samples_win.setpos(0, 0)
        @samples_win.attrset(A_REVERSE)
        @samples_win.addstr('*** Samples ***'.center(cols - 20, ' '))
        @samples_win.attrset(A_NORMAL)

        num_samples = @mod.num_samples
        sample_break = num_samples == 15 ? num_samples : num_samples / 2
        (0..num_samples).each do |i|
          x, y = i > sample_break ? [i - (sample_break - 1), 32] : [i + 2, 2]
          @samples_win.setpos(x, y)
          @samples_win.addstr("#{i}: #{@mod.sample_name(i)}")
        end

        @samples_win.refresh
      end

      def help
        @help_open ? draw : draw_help
        @help_open = !@help_open
      end

      def draw_help
        @help_win.box('|', '-')
        @help_win.setpos(0, 0)
        @help_win.attrset(A_REVERSE)
        @help_win.addstr('*** Help ***'.center(cols - 20, ' '))
        @help_win.attrset(A_NORMAL)

        line = 3
        HELP_TEXT.each do |key, text|
          @help_win.setpos(line, 2)
          @help_win.addstr("#{key.rjust(8)} - #{text}")
          line += 1
        end

        @help_win.refresh
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
