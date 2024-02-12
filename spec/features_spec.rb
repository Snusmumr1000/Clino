# frozen_string_literal: true

require "rspec"

require_relative "fixtures/hello_world_min"
require_relative "fixtures/ideal_weight_cli"
require_relative "fixtures/random_generator_cli"

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
    while generated_number != 2.0 do generated_number = RANDOM_GENERATOR_CLI.start_raw(%w[1 2 --alg uni --i]) end
    expect(generated_number).to eq(2.0)

    generated_number = nil
    while generated_number != 2.0 do generated_number = RANDOM_GENERATOR_CLI.start_raw(%w[1 2 --alg uni --incl]) end
    expect(generated_number).to eq(2.0)

    generated_number = nil
    while generated_number != 2.0 do generated_number = RANDOM_GENERATOR_CLI.start_raw(%w[1 2 --alg uni -i]) end
    expect(generated_number).to eq(2.0)
  end
end
