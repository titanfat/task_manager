# frozen_string_literal: true

class Sprint::TaskFetch
  include Interactor

  before do
    @sprint = Sprint.find_by(id: context.payload[:sprint_id])
  end

  def call
    external_task = Wrapper::IssuesSyncWrapper.new(@sprint)
    if external_task.present?
      tasks ||= external_task.call()
      add_tasks(tasks)
    end
  # external_task.errors.empty? ? Success(external_task) : Failure(external_task:errors)
  # TODO: create base interactor with dry monads & validation
  end


  def add_tasks(tasks)
    return unless tasks.length > 0

    project_admin = @sprint.admins&.first

    tasks.each do |task|

      history_payload = {
        external_id: task[:id],
        creator: { email: task[:creator][:email], full_name: task[:creator][:full_name] }
      }

      ActiveRecord::Base.transaction(isolation: :read_committed) do
        @sprint.tasks.new do |t|
          t.title = task[:title]
          t.description = !!task[:description] ? task[:description] : ""
          t.priority = 0
          t.status = task[:status].include?('В работе') ? 'processing' : 'new'
          t.history = history_payload
          t.author_id = project_admin&.id
          t.save!
        end
      end
    end
  end

end