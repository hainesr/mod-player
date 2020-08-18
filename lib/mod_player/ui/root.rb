# frozen_string_literal: true

# Copyright (c) 2019, 2020 Robert Haines.
#
# Licensed under the BSD License. See LICENCE for details.

require 'curses'

require_relative 'constants'
require_relative 'help_screen'
require_relative 'names_list'

module ModPlayer
  module UI
    class Root
      include Curses

      attr_reader :mod

      def initialize(mod)
        @mod = mod
        @duration = print_time(@mod.duration)
        @paused = false
        @occluded = nil
      end

      def open
        init_screen
        noecho
        curs_set(0)
        @window = Window.new(lines, cols, 0, 0)
        @window.nodelay = true

        @help = HelpScreen.new
        @instruments = NamesList.new(@mod, 'instrument', 1)
        @samples = NamesList.new(@mod, 'sample', 1)
      end

      def close
        @window.close
        close_screen
      end

      def listen
        case @window.getch
        when 'h'
          toggle_dialog(@help)
        when 'i'
          toggle_dialog(@instruments)
        when 'p', ' '
          @paused = !@paused
        when 'q', 27 # ESC
          exit
        when 's'
          toggle_dialog(@samples)
        end
      end

      def draw
        @window.clear

        draw_header
        draw_static_info
        update
        draw_footer

        @window.refresh
      end

      def update
        return if @occluded

        @window.setpos(15, 0)
        @window.addstr("Position...: #{print_time(@mod.position)}")
        @window.addstr(" / #{@duration}")
      end

      def paused?
        @paused
      end

      private

      def toggle_dialog(dialog)
        # This dance allows us to open dialogs on top of already open
        # dialogs and still retain some semblance of expected behaviour.
        if @occluded.nil?
          dialog.draw
          @occluded = dialog
        elsif @occluded == dialog
          @occluded = nil
          draw
        else
          # Set to nil briefly so dynamic parts of the UI don't disappear.
          # We need to redraw the root window to erase the open dialog box.
          @occluded = nil
          draw
          dialog.draw
          @occluded = dialog
        end
      end

      def print_time(time)
        Time.at(time).strftime("%M:%S.%L")
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
