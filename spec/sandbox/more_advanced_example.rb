# frozen_string_literal: true

# !/usr/bin/env ruby

require "securerandom"
require_relative "../../lib/adapters/cli"

class RandomGeneratorCLI
  include Cli

  desc "Generate a random number"
  opt :alg, aliases: ["-a"], type: :string, desc: "Algorithm to use (uni or exp)"
  opt :incl, aliases: ["-i"], type: :boolean, default: true, desc: "Include upper bound"
  arg :from, type: :integer, desc: "Lower bound"
  arg :to, type: :integer, desc: "Upper bound"
  arg :mult, type: :float, default: 1, desc: "Multiplier"

  def run(from, to, mult, alg:, incl:)
    raise ArgumentError, "The lower bound (#{from}) must be less than the upper bound (#{to})" if from >= to
    raise ArgumentError, "Algorithm must be one of: [uni, exp]" unless %w[uni exp].include?(alg)

    send("generate_rnd_#{alg}", from, to, incl) * mult
  end

  private

  def generate_rnd_uni(from, to, incl)
    range = incl ? from..to : from...to
    rand(range)
  end

  def generate_rnd_exp(from, to, _incl)
    mean = (from + to) / 2.0
    -mean * Math.log(rand) if mean.positive?
  end
end

RandomGeneratorCLI.start
