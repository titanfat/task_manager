class TaskTransition < ActiveRecord::Base
  include Statesman::Adapters::ActiveRecordTransition

  validates :to_state, inclusion: { in: TaskStateMachine.states }

  belongs_to :task, inverse_of: :task_transitions
end
