# frozen_string_literal: true

module ResultObtainer
  def call_method_with_args(signature, method, input)
    positional_values = []
    keyword_values = {}

    signature.args_arr.each do |arg|
      if arg.required?
        positional_values << input[arg.name]
      else
        positional_values << input[arg.name] unless input[arg.name].nil?
      end
    end

    signature.opts.each do |opt_name, opt|
      if opt.required?
        keyword_values[opt_name] = input[opt_name]
      else
        keyword_values[opt_name] = input[opt_name] unless input[opt_name].nil?
      end
    end

    default_opts = signature.default_opts
    default_opts.each do |opt_name, opt|
      keyword_values[opt_name] = opt.default unless keyword_values.key?(opt_name)
    end

    default_args = signature.default_args
    last_default_args_needed = signature.args_arr.length - positional_values.length
    positional_values = positional_values + default_args[-last_default_args_needed..-1]

    method.call(*positional_values, **keyword_values)
  end
end