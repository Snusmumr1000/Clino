# frozen_string_literal: true

require "optparse"

module InputParser
  def parse_input(args_and_opts, signature)
    input = {}
    pos_args = []
    args_and_opts.each do |arg|
      break if arg.start_with?("--")

      pos_args << arg
    end

    opts = args_and_opts[pos_args.length..]

    pos_args.each_with_index do |val, idx|
      arg = signature.args_arr[idx]
      input[arg.name] = load_input arg.type, val if arg
    end

    OptionParser.new do |opt|
      signature.opts.each_key do |name|
        signature_opt = signature.opts[name]
        type = signature_opt.type
        aliases = signature_opt.aliases
        if type == :bool
          # TBD: Here is a bug, it doesn't want to accept switch, but accepts only with [no-] prefix
          opt.on(*aliases, "--[no-]#{name}") do |v|
            input[name] = v
          end
          next
        end

        if signature_opt.required?
          opt.on(*aliases, "--#{name} #{name.upcase}") do |v|
            input[name] = load_input signature.opts[name].type, v
          end
        else
          opt.on(*aliases, "--#{name}") do |v|
            input[name] = load_input signature.opts[name].type, v
          end
        end
      end
      opt.on("--h", "--help", "Prints this help") do
        input[:help] = true
      end
    end.parse!(opts)
    input
  end
end
