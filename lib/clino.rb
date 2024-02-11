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
      pos_args = []
      for arg in args
        if arg.start_with?("-")
          break
        else
          pos_args << arg
        end
      end

      args = args[pos_args.length..-1]

      pos_args.each_with_index do |arg, idx|
        option = @options.each_pair.find { |k, v| v[:idx] == idx }
        @input_options[option[0]] = arg if option
      end

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
          positional_values << @input_options[name] unless @input_options[name].nil?
        when :key
          keyword_values[name] = @input_options[name] unless @input_options[name].nil?
        when :keyreq
          keyword_values[name] = @input_options[name]
        end
      end
      @method.call(*positional_values, **keyword_values)
    end

    def self.print_help
      print "Usage: #{$PROGRAM_NAME}"

      # Print :req and :opt arguments sorted by idx
      @options.filter { |_, option| !option[:idx].nil? }.sort_by { |_, option| option[:idx] }.each do |name, option|
        if option[:type] == :req
          print " #{name}"
        elsif option[:type] == :opt
          print " [#{name}]"
        end
      end

      # puts ""

      # Print :keyreq and :key arguments
      @options.each do |name, option|
        print " --#{name} #{name.upcase}" if option[:type] == :keyreq
      end

      @options.each do |name, option|
        print " [--#{name} #{name.upcase}]" if option[:type] == :key
      end

      puts ""

      puts "-h, --help, Prints this help"
    end
  end
end
