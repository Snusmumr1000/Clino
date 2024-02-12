#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative "../lib/clino"

def _generate_rnd(from, to, incl)
  if incl
    rand(from..to)
  else
    rand(from...to)
  end
end

def generate_rnd(from, to, incl: false)
  from = Integer(from)
  to = Integer(to)
  incl = incl.to_s.downcase == "true"

  puts _generate_rnd(from, to, incl)
end

Clino::MinFactory.run(:generate_rnd)
