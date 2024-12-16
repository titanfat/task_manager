class Sprint < ApplicationRecord
  has_and_belongs_to_many :users, join_table: :sprints_users
  has_many :tasks
end
