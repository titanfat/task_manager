# frozen_string_literal: true

module Types
  include Dry.Types()
end

module TaskStruct
  class History < Dry::Struct
    transform_keys(&:to_sym)


    attribute :external_id, Types::String.optional.default("")
    attribute :creator, Types::Hash.schema(
      email: Types::String.optional.default(""),
      name: Types::String.optional.default(""),
    ).optional.default {{}}.meta(shared: true)
  end
end