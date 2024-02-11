# frozen_string_literal: true

require_relative "../domain/domain"
require_relative "../domain/signature/cli_signature"
require "optparse"

class Min
  def initialize(command)
    @input = {}
    @method = method command
    @signature = CliSignature.from_func @method
  end

  def run(args = ARGV)
    parse_options args

    if @input[:help]
      print_help
      return
    end

    call_method_with_args
  end

  def parse_options(args)
    pos_args = []
    args.each do |arg|
      break if arg.start_with?("-")

      pos_args << arg
    end

    args = args[pos_args.length..]

    pos_args.each_with_index do |val, idx|
      arg = @signature.args_arr[idx]
      @input[arg.name] = val if arg
    end

    OptionParser.new do |opts|
      @signature.opts.each_key do |name|
        opts.on("--#{name} #{name.upcase}") do |v|
          @input[name] = v
        end
      end
      opts.on("-h", "--help", "Prints this help") do
        @input[:help] = true
      end
    end.parse!(args)
  end

  def call_method_with_args
    positional_values = []
    keyword_values = {}

    @signature.args_arr.each do |arg|
      if arg.required?
        positional_values << @input[arg.name]
      else
        positional_values << @input[arg.name] unless @input[arg.name].nil?
      end
    end

    @signature.opts.each do |opt_name, opt|
      if opt.require
        keyword_values[opt_name] = @input[opt_name]
      else
        keyword_values[opt_name] = @input[opt_name] unless @input[opt_name].nil?
      end
    end

    @method.call(*positional_values, **keyword_values)
  end

  def print_help
    puts @signature.help
  end
end
