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

def generate_rnd(from, to, mult, alg:, incl:)
  raise ArgumentError, "The lower bound (#{from}) must be less than the upper bound (#{to})" if from >= to
  raise ArgumentError, "Algorithm must be one of: [uni, exp]" unless %w[uni exp].include?(alg)

  send("generate_rnd_#{alg}", from, to, incl) * mult
end

Clino::MinFactory.run(Cmd.new(
                        args: {
                          from: InputTypes::Integer.new,
                          to: InputTypes::Integer.new,
                          mult: InputTypes::Float.new(2)
                        },
                        opts: {
                          alg: InputTypes::String.new,
                          incl: InputTypes::Boolean.new(true)
                        },
                        method: :generate_rnd,
                        output_handler: ->(result) { puts result }
                      ))
