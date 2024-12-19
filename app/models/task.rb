class Task < ApplicationRecord
  belongs_to :sprint, inverse_of: :tasks, class_name: 'Sprint', foreign_key: 'sprint_id', counter_cache: true, optional: true
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'
  belongs_to :executor, class_name: 'User', foreign_key: 'executor_id', optional: true

  validates :title, uniqueness: true, length: { maximum: 255 }, presence: true
  validates :priority, numericality: { only_integer: true }, presence: true

  # TO-DO after state machine/custom status
  # validates :status, presence: true

  scope :in_backlog, -> { where(status: 'backlog') }

end
