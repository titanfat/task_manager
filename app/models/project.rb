class Project < ApplicationRecord
  validates :name, presence: true
  has_many :sprints, dependent: :destroy, counter_cache: true
end
