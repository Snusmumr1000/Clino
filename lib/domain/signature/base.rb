# frozen_string_literal: true

module Base
  BaseSignatureStruct = Struct.new(:name, :type, :default, :desc)

  module BaseSignatureValidator
    def self.included(base)
      base.class_eval do
        # Override Struct's initialize method to include validation
        def initialize(name:, type: :string, default: :none, desc: nil, **others)
          super(name, type, default, desc, *others.values)
          validate_name(name)
        end
      end
    end

    def validate_name(name)
      raise ArgumentError, "Name must be a symbol" unless name.is_a?(Symbol)
    end
  end

  module BaseSignature
    include BaseSignatureValidator
    def required?
      default == :none
    end
  end

  ArgSignature = Struct.new(*BaseSignatureStruct.members, :pos) do
    include BaseSignature
    def initialize(name:, type: :string, default: :none, desc: nil, pos: nil)
      super
    end
  end

  OptSignature = Struct.new(*BaseSignatureStruct.members, :aliases) do
    include BaseSignature
    def initialize(name:, type: :string, default: :none, desc: nil, aliases: [])
      super
    end
  end
end
