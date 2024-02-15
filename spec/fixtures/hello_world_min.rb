# frozen_string_literal: true

require_relative "../../lib/clino/interfaces/min"

HELLO_WORLD_MIN = Min.new(->(name) { "Hello, #{name}!" })
