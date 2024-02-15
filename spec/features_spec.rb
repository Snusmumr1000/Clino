# frozen_string_literal: true

require "rspec"
require "base64"

require_relative "fixtures/hello_world_min"
require_relative "fixtures/ideal_weight_cli"
require_relative "fixtures/random_generator_cli"
require_relative "fixtures/reverse_text_min"
require_relative "fixtures/decoder_min"
require_relative "fixtures/cut_min"

RSpec.describe "Features" do
  before do
    # Do nothing
  end

  after do
    # Do nothing
  end

  it "throws an error when missing a required argument" do
    expect { HELLO_WORLD_MIN.start([]) }.to raise_error(ArgumentError)
  end

  it "correctly interprets a single argument" do
    expect(HELLO_WORLD_MIN.start_raw(["World"])).to eq("Hello, World!")
  end

  it "correctly registers type" do
    expect { IDEAL_WEIGHT_CLI.start(["World"]) }.to raise_error(ArgumentError)
    expect { IDEAL_WEIGHT_CLI.start(["-1"]) }.to raise_error(ArgumentError)
    expect(IDEAL_WEIGHT_CLI.start_raw(["170"])).to eq(63.0)
  end

  it "works with short names for arguments" do
    generated_number = nil
    generated_number = RANDOM_GENERATOR_CLI.start_raw(%w[1 2 --alg uni -i]) while generated_number != 2.0
    expect(generated_number).to eq(2.0)

    generated_number = nil
    generated_number = RANDOM_GENERATOR_CLI.start_raw(%w[1 2 --alg uni --incl]) while generated_number != 2.0
    expect(generated_number).to eq(2.0)

    generated_number = nil
    generated_number = RANDOM_GENERATOR_CLI.start_raw(%w[1 2 --alg uni -i]) while generated_number != 2.0
    expect(generated_number).to eq(2.0)
  end

  it "works with optional arguments" do
    text = REVERSE_TEXT_MIN.start_raw []
    expect(text).to eq("Example".reverse)

    text = REVERSE_TEXT_MIN.start_raw ["Hello"]
    expect(text).to eq("Hello".reverse)
  end

  it "works with required options" do
    # expect { DECODER_MIN.start([]) }.to raise_error(ArgumentError)

    res = DECODER_MIN.start_raw(%w[--text Hello])
    expect(res).to eq("Hello".reverse)

    world_base64 = Base64.encode64("World")
    res = DECODER_MIN.start_raw(["--text", world_base64, "--enc", "base64"])
    expect(res).to eq("World")
  end
  
  it "replaces underscores with dashes in option and arg names" do
    res = CUT_MIN.start_raw(%w[Hello --cut-text o])
    expect(res).to eq("Hell")
  end 
end
