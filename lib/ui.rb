# frozen_string_literal: true

# Copyright (c) 2018 Robert Haines.
#
# Licensed under the BSD License. See LICENCE for details.

require 'curses'

require 'version'

module ModPlayer
  class UI

    include Curses

    TITLE = "Ruby Mod Player (v #{ModPlayer::VERSION})"

    def initialize(mod)
      @mod = mod
    end

    def open
      init_screen
      noecho
      curs_set(0)
      @window = Window.new(lines, cols, 0, 0)
      @window.nodelay = true
      @centre = cols / 2
      @middle = lines / 2
    end

    def close
      @window.close
      close_screen
    end

    def listen
      ch = @window.getch

      exit if ch == 'q'
      draw if ch == 'r'
    end

    def draw
      @window.clear

      header

      @window.setpos(5, 0)
      @window.addstr(@mod.title)
      @window.setpos(7, 0)
      @window.attrset(A_NORMAL)
      @window.addstr(mod_duration_string)

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

    def header
      @window.attrset(A_REVERSE)
      @window.setpos(0, 0)
      @window.addstr(TITLE.center(cols, ' '))
      @window.attrset(A_NORMAL)
    end

    def footer
      @window.attrset(A_REVERSE)
      @window.setpos(lines - 1, 0)
      @window.addstr(TITLE.center(cols, ' '))
      @window.attrset(A_NORMAL)
    end
  end
end
