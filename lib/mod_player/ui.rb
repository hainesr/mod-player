# frozen_string_literal: true

# Copyright (c) 2018, 2019 Robert Haines.
#
# Licensed under the BSD License. See LICENCE for details.

require 'mod_player/version'

module ModPlayer
  module UI
    HEADER_TEXT = '*** Ruby Mod Player ***'
    FOOTER_TEXT = [
      "Press 'h' to toggle help; 'q' to quit",
      "*** Version #{ModPlayer::VERSION} *** (c) Robert Haines, 2018, 2019 ***"
    ].freeze

    HELP_TITLE = 'Help'
    HELP_TEXT = [
      ['h', 'toggle this help screen'],
      ['space, p', 'pause/resume playback'],
      ['s', 'show sample names'],
      ['esc, q', 'quit']
    ].freeze

    SAMPLES_TITLE = 'Samples'
  end
end
