# frozen_string_literal: true

require_relative "Clinohumite/version"
require "optparse"
require "set"

module Clino
  # Comment
  module MinFactory
    @method = nil
    @options = {}
    @input_options = {}

    def self.run(command, args = ARGV)
      @method = method command
      generate_cmd @method

      parse_options args
      print_help and return if @input_options[:help]

      call_method_with_args
    end

    def self.generate_cmd(method_)
      method_.parameters.each_with_index do |param, idx|
        type = param[0]
        positional_params = Set.new(%i[req opt])
        @options[param[1]] = {
          type: type,
          idx: positional_params.include?(type) ? idx : nil
        }
      end
    end

    def self.parse_options(args)
      OptionParser.new do |opts|
        @options.each do |name, _|
          opts.on("--#{name} #{name.upcase}") do |v|
            @input_options[name] = v
          end
        end
        opts.on("-h", "--help", "Prints this help") do
          @input_options[:help] = true
        end
      end.parse!(args)
    end

    def self.call_method_with_args
      positional_values = []
      @options.each do |name, option|
        if option[:idx]
          positional_values[option[:idx]] = @input_options[name]
          next
        end
      end
      print(@method.call(*positional_values))
    end

    def print_help
      puts "Usage: #{@method.name} [options]"
      @options.each do |name|
        puts "--#{name} #{name.upcase}"
      end
      puts "-h, --help, Prints this help"
    end
  end
end
