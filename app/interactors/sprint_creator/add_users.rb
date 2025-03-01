# frozen_string_literal: true

module SprintCreator
  class AddUsers
    include Interactor

    def call
      current_sprint = add_users context[:sprint_id]


      # if context.success
      #   context.success
      # else
      #   context.fail!(message: "Sprint fail #{current_sprint.errors}")
      # end
    end

    def add_users(id)
      sprint = Sprint.find_by(id:)
      return unless sprint

      project_users = sprint.project.users.pluck(:id)

      sprint.user_ids = (project_users + sprint.user_ids).uniq
      sprint.save!
    end

  end
end