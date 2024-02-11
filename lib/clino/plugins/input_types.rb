# frozen_string_literal: true

class InputTypes
  def initialize
    @converters = {}
    register(:float, method(:convert_float))
    register(:integer, method(:convert_integer))
    register(:bool, method(:convert_bool))
    register(:string, method(:convert_string))
  end

  def register(type, converter)
    raise ArgumentError, "Invalid converter" unless converter.respond_to?(:call)
    raise ArgumentError, "Invalid type" unless type.is_a?(Symbol)

    @converters[type] = converter
  end

  def convert(type, value)
    raise ArgumentError, "Invalid type: #{type}, available types: #{@converters.keys}" unless @converters.key?(type)

    @converters[type].call(value)
  end

  def convert_float(value = nil)
    return nil if value.nil?

    value.to_f
  end

  def convert_integer(value = nil)
    return nil if value.nil?

    value.to_i
  end

  def convert_bool(value = nil)
    return nil if value.nil?

    if [true, false].include?(value)
      value
    else
      true_values = %w[true yes 1 t y]
      falsy_values = %w[false no 0 f n]
      if true_values.include?(value.downcase)
        true
      elsif falsy_values.include?(value.downcase)
        false
      else
        raise ArgumentError, "Invalid boolean value: #{default}"
      end
    end
  end

  def convert_string(value = nil)
    return nil if value.nil?

    value.to_s
  end
end

INPUT_TYPES_PLUGIN = InputTypes.new

def load_input(type, value)
  INPUT_TYPES_PLUGIN.convert(type, value)
end
