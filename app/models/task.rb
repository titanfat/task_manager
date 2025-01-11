# == Schema Information
#
# Table name: tasks
#
#  id          :bigint           not null, primary key
#  body        :text
#  description :text
#  end_date    :date
#  history     :jsonb            not null
#  lead_time   :integer
#  priority    :integer          default(0), not null
#  start_date  :date
#  status      :string           not null
#  tags        :string           default([]), not null, is an Array
#  title       :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  author_id   :bigint           not null
#  executor_id :bigint
#  sprint_id   :bigint
#
# Indexes
#
#  index_tasks_on_author_id                            (author_id)
#  index_tasks_on_executor_id                          (executor_id)
#  index_tasks_on_sprint_id                            (sprint_id)
#  index_tasks_on_status_and_priority_and_executor_id  (status,priority,executor_id)
#  index_tasks_on_tags                                 (tags) USING gin
#  index_tasks_on_title                                (title) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (author_id => users.id)
#  fk_rails_...  (executor_id => users.id)
#  fk_rails_...  (sprint_id => sprints.id)
#
class Task < ApplicationRecord
  belongs_to :sprint, inverse_of: :tasks, class_name: 'Sprint', foreign_key: 'sprint_id', counter_cache: true,
                      optional: true
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'
  belongs_to :executor, class_name: 'User', foreign_key: 'executor_id', optional: true
  has_many :task_transitions, autosave: false
  validates :title, uniqueness: true, length: { maximum: 255 }, presence: true
  validates :priority, numericality: { only_integer: true }, presence: true

  include Statesman::Adapters::ActiveRecordQueries[
    transition_class: TaskTransition,
    initial_state: TaskStateMachine.initial_state
  ]
  # TO-DO after state machine/custom status

  scope :in_backlog, -> { where(status: 'backlog') }

  delegate :can_transition_to?,
           :current_state, :history, :last_transition, :last_transition_to,
           :transition_to!, :transition_to, :in_state?, to: :state_machine

  def state_machine
    @state_machine ||= TaskStateMachine.new(self, transition_class: TaskTransition)
  end
end
