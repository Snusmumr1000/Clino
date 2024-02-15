# frozen_string_literal: true

require_relative "../../lib/clino/interfaces/min"
require "base64"

DECODER_MIN = Min.new(lambda { |text:, enc: :rev|
  enc = enc.to_sym
  case enc
  when :rev
    text.reverse
  when :rot13
    text.tr("A-Za-z", "N-ZA-Mn-za-m")
  when :base64
    Base64.decode64(text)
  else
    raise ArgumentError, "Invalid encoding: #{enc}"
  end
})
