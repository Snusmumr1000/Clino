# frozen_string_literal: true

require_relative "Clinohumite/version"
require "optparse"
require "set"

POSITIONAL_PARAMS = Set.new(%i[req opt])

# Clinohumite
module Clino
  # Comment
  module MinFactory
    @method = nil
    @options = {}
    @input_options = {}

    def self.run(command, definition = nil, args = ARGV)
      @method = method command
      generate_cmd @method if definition.nil?

      parse_options args

      if @input_options[:help]
        print_help
        return
      end

      call_method_with_args
    end

    def self.generate_cmd(method_)
      method_.parameters.each_with_index do |param, idx|
        type = param[0]
        @options[param[1]] = {
          type: type,
          idx: POSITIONAL_PARAMS.include?(type) ? idx : nil
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
      keyword_values = {}
      @options.each do |name, option|
        case option[:type]
        when :req
          positional_values << @input_options[name]
        when :opt
          positional_values << @input_options[name]
        when :key
          keyword_values[name] = @input_options[name]
        when :keyreq
          keyword_values[name] = @input_options[name]
        end
      end
      @method.call(*positional_values, **keyword_values)
    end

    def self.print_help
      puts "Usage: #{$0} [options]"
      @options.each do |name, _|
        puts "--#{name} #{name.upcase}"
      end
      puts "-h, --help, Prints this help"
    end
  end
end
