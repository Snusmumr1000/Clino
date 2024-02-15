# frozen_string_literal: true

require "clino/interfaces/min"

Min.new(->(name) { "Hello, #{name}!" }).start
