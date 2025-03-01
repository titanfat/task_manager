# frozen_string_literal: true

module TaskStruct
  class HistoryType < ActiveModel::Type::Value
    def type
      :jsonb
    end

    def cast_value(value)
      return TaskStruct::History.new if value.blank?

      parsed_value =
        case value
        when String
          begin
            JSON.parse(value)
          rescue JSON::ParserError
            {}
          end
        when Hash
          value
        when TaskStruct::History
          return value
        else
          {}
        end

      symbolized_value = if parsed_value.is_a?(Hash)
                           parsed_value.deep_symbolize_keys
                         else
                           {}
                         end

      TaskStruct::History.new(symbolized_value)
    end

    def serialize(value)
      return nil if value.blank?

      data = case value
             when TaskStruct::History then value.to_h
             when Hash then value
             else {}
             end

      JSON.generate(data.deep_stringify_keys)
    end
  end
end