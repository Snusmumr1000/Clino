# frozen_string_literal: true

require_relative "../../lib/clino/interfaces/min"

CUT_MIN = Min.new(->(src_text, cut_text:) { src_text.gsub(cut_text, "") })
