# frozen_string_literal: true

# Copyright (c) 2018 Robert Haines.
#
# Licensed under the BSD License. See LICENCE for details.

require 'curses'

require 'version'

module ModPlayer
  class UI

    include Curses

    HEADER_TEXT = '*** Ruby Mod Player ***'
    FOOTER_TEXT =
      "*** Version #{ModPlayer::VERSION} *** (c) Robert Haines, 2018 ***"

    def initialize(mod, path)
      @mod = mod
      @mod_file = ::File.basename(path)
      @mod_size = ::File.size(path) / 1_024

      @help_open = false
    end

    def open
      init_screen
      noecho
      curs_set(0)
      @window = Window.new(lines, cols, 0, 0)
      @window.nodelay = true

      @help_win = Window.new(lines - 10, cols - 20, 5, 10)
    end

    def close
      @window.close
      close_screen
    end

    def listen
      ch = @window.getch

      exit if ch == 'q'
      help if ch == 'h'
    end

    def draw
      @window.clear

      header
      static_info
      footer

      @window.refresh
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
      @help_win.refresh
    end

    def header
      @window.attrset(A_REVERSE)
      @window.setpos(0, 0)
      @window.addstr(HEADER_TEXT.center(cols, ' '))
      @window.attrset(A_NORMAL)
    end

    def static_info
      @window.setpos(2, 0)
      @window.addstr("Filename...: #{@mod_file}\n")
      @window.addstr("Size.......: #{@mod_size}k\n\n")
      @window.addstr("Title......: #{@mod.title}\n")
      @window.addstr("Duration...: #{mod_duration_string}\n")
      @window.addstr("Type.......: #{@mod.type}\n")
      @window.addstr("Format.....: #{@mod.type_long}\n")
      @window.addstr("Tracker....: #{@mod.tracker}\n\n")
      @window.addstr("Subsongs...: #{@mod.subsongs}\n")
      @window.addstr("Channels...: #{@mod.channels}\n")
      @window.addstr("Patterns...: #{@mod.patterns}\n")
      @window.addstr("Orders.....: #{@mod.orders}\n")
      @window.addstr("Samples....: #{@mod.samples}\n")
      @window.addstr("Instruments: #{@mod.instruments}\n")
    end

    def footer
      @window.attrset(A_REVERSE)
      @window.setpos(lines - 1, 0)
      @window.addstr(FOOTER_TEXT.center(cols, ' '))
      @window.attrset(A_NORMAL)
    end
  end
end
