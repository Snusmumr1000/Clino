#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative "../../lib/adapters/min"

def generate_rnd_uni(from, to, incl)
  range = incl ? from..to : from...to
  rand(range)
end

def generate_rnd_exp(from, to, _incl)
  mean = (from + to) / 2.0
  -mean * Math.log(rand) if mean.positive?
end

def generate_rnd(from, to, mult = 1.0, alg:, incl: false)
  from = load_input :integer, from
  to = load_input :integer, to
  mult = load_input :float, mult
  incl = load_input :bool, incl

  raise ArgumentError, "The lower bound (#{from}) must be less than the upper bound (#{to})" if from >= to
  raise ArgumentError, "Algorithm must be one of: [uni, exp]" unless %w[uni exp].include?(alg)

  puts send("generate_rnd_#{alg}", from, to, incl) * mult
end

Min.new(:generate_rnd).start
