# frozen_string_literal: true

class Sprint::AddUsers
  include Interactor

  def call
    current_sprint = SprintCreatorJob.perform_async(context.payload[:sprint_id])
    # if context.success
    #   context.success
    # else
    #   context.fail!(message: "Sprint fail #{current_sprint.errors}")
    # end
  end

end