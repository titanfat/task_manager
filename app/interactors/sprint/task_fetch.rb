# frozen_string_literal: true

class Sprint::TaskFetch
  include Interactor

  before do
    context.fail!(error: "Sprint not found") unless sprint.present?
  end

  def call
    external_task = Wrapper::IssuesSyncWrapper.new(sprint)
    tasks ||= external_task.call()
    if tasks.present?
      add_tasks(tasks)
    else
      context.fail!(error: "External tasks not found in jira")
    end
  # external_task.errors.empty? ? Success(external_task) : Failure(external_task:errors)
  # TODO: create base interactor with dry monads & validation
  end


  def add_tasks(tasks)
    return unless tasks.any?

    project_admin = @sprint.admins&.first || @sprint.project.users.where(role: "admin")&.first
    raise "Project admin not found" unless project_admin

    tasks.each do |task|
      ActiveRecord::Base.transaction(isolation: :read_committed) do
        @sprint.tasks.create!(
          title: task[:title],
          description: task[:description].presence || "",
          priority: 0,
          status: task[:status].include?('В работе') ? 'processing' : 'new',
          author_id: project_admin&.id,
          history: {
            external_id: task[:id],
            author_email: task[:creator][:email],
            author_name: task[:creator][:full_name]
          }
        )
      end
    end
  end

  private

  def sprint
    @sprint ||= Sprint.find_by(id: context.payload[:sprint_id])
  end
end