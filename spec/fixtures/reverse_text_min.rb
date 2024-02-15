# frozen_string_literal: true

require_relative "../../lib/clino/interfaces/min"

REVERSE_TEXT_MIN = Min.new(->(text = "Example") { text.reverse })
