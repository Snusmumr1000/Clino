# frozen_string_literal: true

require_relative "../../common/utils"
require_relative "../../plugins/input_types"

class CliSignature
  attr_reader :args, :opts, :args_arr
  attr_accessor :description

  def initialize
    @args = {}
    @args_arr = []
    @opts = {}
    @description = nil
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

    program_name = $PROGRAM_NAME
    @help = "Script: #{program_name}\n"

    unless @description.nil?
      @help += "\nDescription:\n"
      @help += "  #{@description}\n"
    end

    unless @args_arr.empty?
      @help += "\nArguments:\n"
      @args_arr.each do |arg|
        arg_part = "  #{arg.required? ? "<#{arg.name}>" : "[<#{arg.name}>]"}"
        arg_desc = arg.desc ? " # #{arg.desc}" : ""
        arg_default = arg.default != :none ? " [default: #{load_input arg.type, arg.default}]" : ""
        arg_type = " [#{arg.type}]"
        @help += "#{arg_desc}\n#{arg_part}#{arg_type}#{arg_default}\n"
      end
    end

    unless @opts.empty?
      @help += "\nOptions:\n"
      @opts.each do |name, option|
        opt_part = "  #{option.required? ? "--#{name}" : "[--#{name}]"}"
        if option.aliases && !option.aliases.empty?
          aliases = option.aliases.join(", ")
          opt_part += " (#{aliases})"
        end
        opt_desc = option.desc ? " # #{option.desc}" : ""
        opt_default = option.default != :none ? " [default: #{option.default}]" : ""
        opt_type = " [#{option.type}]"
        @help += "#{opt_desc}\n#{opt_part}#{opt_type} #{opt_default}\n"
      end
    end

    @help += "\nUsage: #{program_name} [arguments] [options]"

    @help += "\nUse --h, --help to print this help message.\n"

    @help
  end

  def self.from_func(func)
    arg_types = %i[req opt]
    opt_types = %i[key keyreq]
    signature = CliSignature.new
    func.parameters.each_with_index do |param, idx|
      param_type, param_name = param
      if arg_types.include?(param_type)
        arg = Base::ArgSignature.new(
          name: param_name,
          pos: idx
        )
        arg.default = :unknown if param_type == :opt
        signature.add_arg arg
      elsif opt_types.include?(param_type)
        opt = Base::OptSignature.new(
          name: param_name
        )
        opt.default = :unknown if param_type == :key
        signature.add_opt opt
      end
    end
    signature
  end

  def default_opts
    opts = {}
    @opts.each do |name, opt|
      opts[name] = opt.default unless opt.required?
    end
    opts
  end

  def default_args
    args = []
    @args_arr.each do |arg|
      args << arg.default unless arg.required?
    end
    args
  end

  def allowed_options
    if @allowed_options.nil?
      @allowed_options = Set.new
      @allowed_option_to_name = {}
      @opts.each_value do |opt|
        long_opt = "--#{opt.name}"
        @allowed_options.add(long_opt)
        @allowed_option_to_name[long_opt] = opt.name
        opt.aliases.each do |alias_|
          @allowed_options.add(alias_)
          @allowed_option_to_name[alias_] = opt.name
        end
      end
    end
    @allowed_options
  end

  def allowed_option_to_name
    if @allowed_option_to_name.nil?
      allowed_options
    end
    @allowed_option_to_name
  end
end
