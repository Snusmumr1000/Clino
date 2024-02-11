# frozen_string_literal: true

require_relative "../domain/signature/cli_signature"
require_relative "../domain/domain"

class Cli
  class << self
    attr_reader :opt_buffer, :arg_buffer, :description

    def desc(description)
      @description = description
    end

    def opt(name, type: :string, desc: nil, aliases: [], default: :none)
      @opt_buffer ||= {}
      @opt_buffer[name] = Domain::OptSignature.new(name: name, type: type, default: default, desc: desc,
                                                   aliases: aliases)
    end

    def arg(name, type: :string, desc: nil, default: :none, pos: nil)
      @arg_buffer ||= {}
      @arg_buffer[name] = Domain::ArgSignature.new(name: name, type: type, default: default, desc: desc, pos: pos)
    end
  end

  def initialize
    @input = {}
    @signature ||= CliSignature.from_func method(:run)
    @signature.args_arr.each do |arg|
      self.class.arg_buffer[arg.name].pos = arg.pos
      @signature.add_arg(self.class.arg_buffer[arg.name])
    end

    @signature.opts.each_key do |name|
      @signature.add_opt(self.class.opt_buffer[name])
    end

    @signature.description = self.class.description
  end

  def start(args = ARGV)
    # This method should parse the CLI arguments and options, matching them against the defined args and opts.
    # Actual implementation depends on how you want to parse and use command-line inputs.
    puts "CLI started with args: #{args.inspect}"
    print_help
  end

  def print_help
    puts @signature.help
  end
end
