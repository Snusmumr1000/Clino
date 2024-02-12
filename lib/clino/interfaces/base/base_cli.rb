# frozen_string_literal: true

module BaseCli
  include InputParser
  include ResultObtainer

  def start(args = ARGV)
    input = parse_args_by_signature args
    return if input.nil?

    print_result run_instance input
  end

  def start_raw(args)
    input = parse_args_by_signature args
    return if input.nil?

    run_instance input
  end

  def parse_args_by_signature(args)
    input = parse_input args, @signature

    if input[:help]
      print_help
      return nil
    end

    input
  end

  def run_instance(input)
    call_method_with_args @signature, @method, input
  end

  def print_help
    puts @signature.help
  end

  def print_result(result)
    puts result
  end
end
