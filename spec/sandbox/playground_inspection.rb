# frozen_string_literal: true
# rubocop:disable all

def demo(one, two = :b, *three, four:, five: :e, **six)
  params = method(:demo).parameters

  puts(one)
  puts(two)
  puts(three)
  puts(four)
  puts(five)
  puts(six)

  params.each do |param|
    type, name = param
    case type
    when :req
      puts "#{name}: Required Argument"
    when :opt
      puts "#{name}: Optional Argument"
    when :rest
      puts "#{name}: Rest Argument"
    when :block
      puts "#{name}: Block Argument"
    when :key
      puts "#{name}: Keyword Argument"
    when :keyreq
      puts "#{name}: Required Keyword Argument"
    when :keyrest
      puts "#{name}: Rest Keyword Argument"
    end
  end
end

d = { four: 42, five: :e }

demo(_one = "Hello", **d) do
  # Some block code
end
