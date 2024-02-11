# frozen_string_literal: true

require_relative "../domain/domain"
require_relative "../domain/input_parser"
require_relative "../domain/signature/cli_signature"
require_relative "../domain/result_obtainer"
require_relative "../plugins/input_types"
require_relative "base/base_cli"
require "optparse"

class Min
  include BaseCli

  def initialize(command)
    @method = method command if command.is_a? Symbol
    @method = command if command.is_a? Method

    @signature = CliSignature.from_func @method
  end
end
