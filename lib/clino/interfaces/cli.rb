# frozen_string_literal: true

require_relative "../domain/signature/cli_signature"
require_relative "../domain/signature/base"
require_relative "../domain/input_parser"
require_relative "../domain/result_obtainer"
require_relative "base/base_cli"

class Cli
  class << self
    attr_reader :description
    def opt_buffer
      @opt_buffer || {}
    end

    def arg_buffer
      @arg_buffer || {}
    end

    def desc(description)
      @description = description
    end

    def opt(name, type: :string, desc: nil, aliases: [], default: :none)
      @opt_buffer ||= {}
      aliases = aliases.map { |a| "-#{general_strip a, "-"}" }
      default = load_input type, default unless default == :none
      @opt_buffer[name] = Base::OptSignature.new(name: name, type: type, default: default, desc: desc,
                                                 aliases: aliases)
    end

    def arg(name, type: :string, desc: nil, default: :none, pos: nil)
      @arg_buffer ||= {}
      default = load_input type, default unless default == :none
      @arg_buffer[name] = Base::ArgSignature.new(name: name, type: type, default: default, desc: desc, pos: pos)
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
      @signature.add_opt(self.class.opt_buffer[name]) if self.class.opt_buffer.key? name
    end

    @signature.description = self.class.description
  end

  include BaseCli
end
