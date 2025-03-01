# frozen_string_literal: true

module SprintCreator
  class TaskFetch
    include Interactor
    include Dry::Monads[:maybe, :result]

    before do
      context.fail!(error: "Sprint not found") unless sprint.present?
    end

    def call
      external_task = Wrapper::IssuesSyncWrapper.new(sprint)
      tasks ||= external_task.call()

      tasks.present? ? Success(add_tasks tasks) : Failure(context.fail! "External tasks not found in jira")
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
            external_history: {
              external_id: task[:id],
              creator: {
                email: task[:creator][:email],
                name: task[:creator][:full_name]
              }
            }
          )
        end
      end
    end

    private

    def sprint
      @sprint ||= Sprint.find_by(id: context[:sprint_id])
    end
  end
end