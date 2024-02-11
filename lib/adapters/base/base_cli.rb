# frozen_string_literal: true

module BaseCli
  include InputParser
  include ResultObtainer

  def start(args = ARGV)
    input = parse_input args, @signature

    if input[:help]
      print_help
      return
    end

    print_result call_method_with_args @signature, @method, input
  end

  def print_help
    puts @signature.help
  end

  def print_result(result)
    puts result
  end
end
