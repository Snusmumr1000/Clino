# frozen_string_literal: true

class Cli
  @args = {}
  @opts = {}
  @description = ""

  class << self
    attr_accessor :args, :opts, :description

    def desc(description)
      @description = description
    end

    def opt(name, type:, desc:, aliases: [], default: nil)
      @opts[name] = Domain::OptSignature.new(name: name.to_s, type: type, default: default, desc: desc)
    end

    def arg(name, type:, desc:, default: nil, pos: nil)
      @args[name] = Domain::ArgSignature.new(name: name.to_s, type: type, default: default, desc: desc, pos: pos)
    end

    def start
      # This method should parse the CLI arguments and options, matching them against the defined args and opts.
      # Actual implementation depends on how you want to parse and use command-line inputs.
      puts "CLI started with description: #{@description}"
      list_options_and_arguments
    end

    def list_options_and_arguments
      puts "Options:"
      @opts.each { |name, opt| puts "  #{name}: #{opt.desc}" }
      puts "Arguments:"
      @args.each { |name, arg| puts "  #{name}: #{arg.desc}" }
    end
  end
end
