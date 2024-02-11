#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative "../../lib/clino"

def _generate_rnd_uni(from, to, incl)
  if incl
    rand(from..to)
  else
    rand(from...to)
  end
end

def _generate_rnd_exp(from, to, _incl)
  mean = (from + to) / 2
  -mean * Math.log(rand) if mean.positive?
end

def generate_rnd(from, to, mult = 1, alg:, incl: false)
  from = Integer(from)
  to = Integer(to)
  mult = Integer(mult)
  incl = incl.to_s.downcase == "true"

  raise ArgumentError, "The lower bound (#{from}) must be less than the upper bound (#{to})" if from >= to
  raise ArgumentError, "Algorithm must be one of: [uni, exp]" unless %w[uni exp].include?(alg)

  generators = {
    "uni" => method(:_generate_rnd_uni),
    "exp" => method(:_generate_rnd_exp)
  }

  puts generators[alg].call(from, to, incl) * mult
end

Clino::MinFactory.run(:generate_rnd)
