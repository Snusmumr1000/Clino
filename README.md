# Clino

Clino (originally Clinohumite) gem is a CLI builder library that provides a simple way to create a command line interface for your Ruby application. 

It is inspired by the [Thor](https://github.com/rails/thor) and [Typer](https://github.com/tiangolo/typer) libraries, and aims to provide a simple and easy to use interface for building command line interfaces.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'clino'
```

## Usage

### Interfaces
There are two interfaces available: `Min` and `Cli`.

#### Min
The `Min` interface is a minimalistic interface that provides a simple way to create a command line interface for your Ruby application. 

It is inspired by the [Typer](https://github.com/tiangolo/typer) pythonic approach

It tries to unleash all the power of Ruby's metaprogramming capabilities to provide a simple and easy to use interface for building command line interfaces.

#### Cli
The `Cli` interface is a more advanced interface that provides a more complex way to create a command line interface for your Ruby application.

It is inspired by the [Thor](https://github.com/rails/thor) library and provides a more complex and feature-rich interface for building command line interfaces.

### Examples

#### Hello World

Let's write a simple script that takes a name as an argument and prints a greeting message.

```ruby
# hello.rb

require "clino/interfaces/min"

def hello(name)
  "Hello, #{name}!"
end

Min.new(:hello).start
```

Writing method containing only business logic is enough, as the input and output handling is done by the `Min` interface.

Run the script with the following command:

```bash
ruby hello.rb World  # => Hello, World!
```

Get help with the following command:

```bash
ruby hello.rb --help
```

or 

```bash
ruby hello.rb --h
```

It will print the following output:

```bash
Script: hello.rb

Arguments:

  <name> [string]

Usage: hello.rb [arguments] [options]
Use --h, --help to print this help message.
```
#### Randomizer Minimalistic Example

Let's write a simple script that generates a random number within a given range with some conditions and transformations.

```ruby
# min_randomizer.rb

require "clino/interfaces/min"

def generate_rnd_uni(from, to, incl)
  range = incl ? from..to : from...to
  rand(range)
end

def generate_rnd_exp(from, to, _incl)
  mean = (from + to) / 2.0
  -mean * Math.log(rand) if mean.positive?
end

def generate_rnd(from, to, mult = 1.0, alg:, incl: false)
  from = load_input :integer, from
  to = load_input :integer, to
  mult = load_input :float, mult
  incl = load_input :bool, incl

  raise ArgumentError, "The lower bound (#{from}) must be less than the upper bound (#{to})" if from >= to
  raise ArgumentError, "Algorithm must be one of: [uni, exp]" unless %w[uni exp].include?(alg)

  send("generate_rnd_#{alg}", from, to, incl) * mult
end

Min.new(:generate_rnd).start
```

As we can see, for more complex (or just non-string) input, we can use the `load_input` method to load the input and validate it.

Anyway, it requires us to write additional logic for validation and error handling.

Run the script with the following command:

```bash
ruby min_randomizer.rb 1 10 --alg uni  # => some number from [1.0, 9.0]
```

Get help with the following command:

```bash
ruby min_randomizer.rb --help
```

or

```bash
ruby min_randomizer.rb --h
```

It will print the following output:

```bash
Script: min_randomizer.rb

Arguments:

  <from> [string]

  <to> [string]

  [<mult>] [string] [default: unknown]

Options:

  --alg [string] 

  [--incl] [string]  [default: unknown]

Usage: min_randomizer.rb [arguments] [options]
Use --h, --help to print this help message.
```

As we can see, ruby's metaprogramming capabilities allow us to create a simple CLI, however it doesn't provide a way to handle complex input.

Unfortunately, ruby doesn't allow inspecting the method's signature default values, so we can handle input only as strings, and we can only show placeholders for default values this way.

#### Randomizer Advanced Example

Let's write an advanced version of the randomizer that has CLI signature.

```ruby
# randomizer.rb

require "securerandom"
require "clino/interfaces/cli"

class RandomGeneratorCLI < Cli
  # include Cli
  desc <<-TEXT
    Generate a random number between the given bounds
    using the specified algorithm and multiply it by the given multiplier
  TEXT
  opt :alg, aliases: ["-a"], type: :string, desc: "Algorithm to use (uni or exp)"
  opt :incl, aliases: ["-i"], type: :bool, default: false, desc: "Include upper bound"
  arg :from, type: :integer, desc: "Lower bound"
  arg :to, type: :integer, desc: "Upper bound"
  arg :mult, type: :float, default: 1, desc: "Multiplier"

  def run(from, to, mult, alg:, incl:)
    raise ArgumentError, "The lower bound (#{from}) must be less than the upper bound (#{to})" if from >= to
    raise ArgumentError, "Algorithm must be one of: [uni, exp]" unless %w[uni exp].include?(alg)

    send("generate_rnd_#{alg}", from, to, incl) * mult
  end

  private

  def generate_rnd_uni(from, to, incl)
    range = incl ? from..to : from...to
    rand(range)
  end

  def generate_rnd_exp(from, to, _incl)
    mean = (from + to) / 2.0
    -mean * Math.log(rand) if mean.positive?
  end
end

RandomGeneratorCLI.new.start
```

Run the script with the following command:

```bash
ruby randomizer.rb 1 10 --alg uni  # => some number from [1.0, 9.0]
```

Get help with the following command:

```bash
ruby randomizer.rb --help
```

or

```bash
ruby randomizer.rb --h
```

It will print the following output:

```bash
Script: randomizer.rb

Description:
      Generate a random number between the given bounds
    using the specified algorithm and multiply it by the given multiplier


Arguments:
 # Lower bound
  <from> [integer]
 # Upper bound
  <to> [integer]
 # Multiplier
  [<mult>] [float] [default: 1.0]

Options:
 # Algorithm to use (uni or exp)
  --alg (-a) [string] 
 # Include upper bound
  [--[no-]incl] (-[no-]i) [bool]  [default: false]

Usage: randomizer.rb [arguments] [options]
Use --h, --help to print this help message.
```

As we can see, all the default values, helping notes, and types are written out, and the input validation is handled automatically.

## Plugins
### Input Types

It is possible to create custom input types for the `Cli` interface.

```ruby
# weight_calculator.rb

require "clino/interfaces/cli"
require "clino/plugins/input_types"

def convert_positive_integer(value)
  raise ArgumentError, "Value must be a positive integer" unless value.to_i.positive?

  value.to_i
end

INPUT_TYPES_PLUGIN.register(:positive_integer, method(:convert_positive_integer))

class IdealWeight < Cli
  arg :height, type: :positive_integer

  def run(height)
    return height * 0.45 if height < 100

    (height - 100) * 0.9
  end
end

IdealWeight.new.start
```

Run the script with the following command:

```bash
ruby weight_calculator.rb 180  # => 72.0
ruby weight_calculator.rb -1 # => ArgumentError: Value must be a positive integer
```

The type will be automatically registered and the help message will be printed as follows:

```bash
Script: weight_calculator.rb

Arguments:

  <height> [positive_integer]

Usage: weight_calculator.rb [arguments] [options]
Use --h, --help to print this help message.
```

## Improvements

- [ ] Add more tests
- [ ] Add better UI/UX in a sense of errors and help messages
- [ ] Fix problem with arguments beginning with "--"
- [ ] Add more input types (JSON?)
- [ ] Add CI/CD
- [ ] Add more examples
- [ ] Create a proper documentation

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/snusmumr1000/Clino. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/Clino/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Clino project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/snusmumr1000/Clino/blob/main/CODE_OF_CONDUCT.md).
