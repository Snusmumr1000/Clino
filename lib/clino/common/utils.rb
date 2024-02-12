# frozen_string_literal: true

def general_strip(str, substring = " ")
  substring_len = substring.length
  str = str[substring_len..] while str.start_with?(substring)
  str = str[0...-substring_len] while str.end_with?(substring)
  str
end

def is_callable_with_parameters?(arg)
  # Check if the argument is callable
  arg.respond_to?(:call) && arg.parameters
end
