# frozen_string_literal: true

module InputTypes
  class Float
    def initialize(default = nil)
      @value = default.to_f unless default.nil?
    end
  end

  class Integer
    def initialize(default = nil)
      @value = default.to_i unless default.nil?
    end
  end

  class Boolean
    def initialize(default = nil)
      return if value.nil?

      if [true, false].include?(default)
        @value = default
      else
        true_values = %w[true yes 1 t y]
        falsy_values = %w[false no 0 f n]
        @value = if true_values.include?(default.downcase)
                   true
                 elsif falsy_values.include?(default.downcase)
                   false
                 else
                   raise ArgumentError, "Invalid boolean value: #{default}"
                 end
      end
    end
  end

  class String
    def initialize(default = nil)
      @value = default.to_s unless default.nil?
    end
  end
end
