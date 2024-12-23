# == Schema Information
#
# Table name: projects
#
#  id            :bigint           not null, primary key
#  name          :string           not null
#  sprints_count :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_projects_on_name  (name) UNIQUE
#
class Project < ApplicationRecord
  validates :name, presence: true
  has_many :sprints, dependent: :destroy, counter_cache: true
  has_many :users, class_name: 'User', dependent: :nullify
end
