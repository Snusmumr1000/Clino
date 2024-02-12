# frozen_string_literal: true

require_relative "../../lib/clino/interfaces/cli"
require_relative "../../lib/clino/plugins/input_types"

def convert_positive_integer(value)
  raise ArgumentError, "Value must be a positive integer" unless value.to_i.positive?

  value.to_i
end

INPUT_TYPES_PLUGIN.register(:positive_integer, method(:convert_positive_integer))

class IdealWeight < Cli
  arg :height, type: :positive_integer

  def run(height)
    return height * 0.45 if height < 100

    (height - 100) * 0.9
  end
end

IDEAL_WEIGHT_CLI = IdealWeight.new
