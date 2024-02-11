# frozen_string_literal: true

require "clino/interfaces/min"

def hello(name)
  "Hello, #{name}!"
end

Min.new(:hello).start
