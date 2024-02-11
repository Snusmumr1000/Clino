# frozen_string_literal: true

require_relative "../domain/signature/cli_signature"
require_relative "../domain/domain"
require_relative "../domain/input_parser"
require_relative "../domain/result_obtainer"
require_relative "base/base_cli"

class Cli
  class << self
    attr_reader :opt_buffer, :arg_buffer, :description

    def desc(description)
      @description = description
    end

    def opt(name, type: :string, desc: nil, aliases: [], default: :none)
      @opt_buffer ||= {}
      bool_prefix = type == :bool ? "[no-]" : ""
      aliases = aliases.map { |a| "-#{bool_prefix}#{general_strip a, "-"}" }
      default = load_input type, default unless default == :none
      @opt_buffer[name] = Domain::OptSignature.new(name: name, type: type, default: default, desc: desc,
                                                   aliases: aliases)
    end

    def arg(name, type: :string, desc: nil, default: :none, pos: nil)
      @arg_buffer ||= {}
      default = load_input type, default unless default == :none
      @arg_buffer[name] = Domain::ArgSignature.new(name: name, type: type, default: default, desc: desc, pos: pos)
    end
  end

  def initialize
    @method = method(:run)
    @signature ||= CliSignature.from_func @method
    @signature.args_arr.each do |arg|
      self.class.arg_buffer[arg.name].pos = arg.pos
      @signature.add_arg(self.class.arg_buffer[arg.name])
    end

    @signature.opts.each_key do |name|
      @signature.add_opt(self.class.opt_buffer[name])
    end

    @signature.description = self.class.description
  end

  include BaseCli
end
