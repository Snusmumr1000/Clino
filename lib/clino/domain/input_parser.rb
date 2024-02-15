# frozen_string_literal: true

require "optparse"

module InputParser
  def parse_input(args_and_opts, signature)
    args_and_opts = args_and_opts.map do |arg|
      idx = 0
      idx += 1 while arg[idx..].start_with?("-") && idx < arg.length
      part_to_replace = arg[idx..].gsub("-", "_")
      arg[0...idx] + part_to_replace
    end

    input = {}
    pos_args = []
    allowed_options = signature.allowed_options
    args_and_opts.each do |arg|
      break if allowed_options.include?(arg)

      pos_args << arg
    end

    opts = args_and_opts[pos_args.length..]

    pos_args.each_with_index do |val, idx|
      arg = signature.args_arr[idx]
      input[arg.name] = load_input arg.type, val if arg
    end

    prev_opt_name = nil
    allowed_option_to_name = signature.allowed_option_to_name
    opts.each do |opt|
      if allowed_options.include?(opt)
        prev_opt_name = allowed_option_to_name[opt]
        input[prev_opt_name] = true
      elsif input[prev_opt_name] == true
        input[prev_opt_name] = load_input signature.opts[prev_opt_name].type, opt
        prev_opt_name = nil
      else
        raise ArgumentError, "Can't parse #{opt} option"
      end
    end

    input
  end
end
