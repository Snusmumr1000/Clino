# frozen_string_literal: true

class CliSignature
  attr_reader :args, :opts, :args_arr

  def initialize
    @args = {}
    @args_arr = []
    @opts = {}
    @help = nil
  end

  def add_arg(arg)
    @args[arg.name] = arg
    @args_arr[arg.pos] = arg
  end

  def add_opt(opt)
    @opts[opt.name] = opt
  end

  def help
    return @help unless @help.nil?

    @help = ""
    @help += "Usage: #{$PROGRAM_NAME}"

    # Print :req and :opt arguments sorted by idx
    @args_arr.each do |arg|
      @help += if arg.required?
                 " #{arg.name}"
               else
                 " [#{arg.name}]"
               end
    end

    @opts.each do |name, option|
      @help += " --#{name} #{name.upcase}" if option.required?
    end

    @opts.each do |name, option|
      @help += " [--#{name} #{name.upcase}]" unless option.required?
    end

    @help += "\n"

    "#{@help}-h, --help, prints this help\n"
  end
end
