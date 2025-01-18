# frozen_string_literal: true

class SprintCreatorJob
  include Sidekiq::Job

  def perform(id)
    sprint = Sprint.find_by(id: id)
    return unless sprint

    project_users = sprint.project.users.pluck(:id)

    sprint.user_ids = (project_users + sprint.user_ids).uniq
    sprint.save!
  end
end
