#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative "../../lib/clino"

def _generate_rnd(from, to, incl)
  if incl
    rand(from..to)
  else
    rand(from...to)
  end
end

def generate_rnd(from, to, incl)
  puts _generate_rnd(from, to, incl)
end

cmd_definition = {
  name: :generate,
  opts: {
    incl: {
      type: :bool,
      default: false,
      desc: "Include the upper bound"
    },
    from: {
      type: :int,
      desc: "The lower bound (inclusive)"
    },
    to: {
      type: :int,
      desc: "The upper bound (exclusive)"
    }
  },
  desc: "Generate a random number"
}

Clino::MinFactory.run(:generate_rnd, cmd_definition)
