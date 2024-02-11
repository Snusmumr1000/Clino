# frozen_string_literal: true

require_relative "../../lib/adapters/min"

def hello(name)
  "Hello, #{name}!"
end

Min.new(:hello).start
