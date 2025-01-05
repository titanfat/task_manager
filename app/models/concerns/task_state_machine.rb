class TaskStateMachine
  include Statesman::Machine

  state :backlog, initial: true
  state :new
  state :processing
  state :testing
  state :completed
  state :canceled

  transition from: :backlog, to: %w[new processing backlog canceled]
  transition from: :new, to: %w[processing backlog canceled]
  transition from: :processing, to: %w[new testing backlog canceled completed]
  transition from: :testing, to: %w[new backlog canceled completed]
  transition from: :completed, to: %w[backlog canceled new testing]
end
