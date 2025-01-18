# frozen_string_literal: true

class Task::History
  include ActiveModel::API
  include ActiveModel::Attributes

  attribute :external_id, :string
  attribute :author_email, :string
  attribute :author_name, :string
  # attribute :creator, Task::History::CreatorType.new

  # class CreatorType < ActiveModel::Type::Value
  #   def cast(value)
  #     return value if value.is_a?(Creator)
  #     return Creator.new(value) if value.is_a?(Hash)
  #
  #     nil
  #   end
  # end
end
#
# class Creator
#   include ActiveModel::API
#   include ActiveModel::Attributes
#
#   attribute :email, :string
#   attribute :full_name, :string
# end