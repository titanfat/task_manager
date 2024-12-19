class Sprint < ApplicationRecord
  has_and_belongs_to_many :users, join_table: :sprints_users, dependent: :destroy
  has_many :tasks, inverse_of: :sprint
  belongs_to :project, inverse_of: :sprints, counter_cache: true

  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :dates_valid


  private

  def dates_valid
    return if start_date.blank? || end_date.blank?

    if start_date > end_date
      errors.add(:start_date, "Sprint cannot be earlier")
    end
  end
end
