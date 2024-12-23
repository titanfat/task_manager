class Sprint::CreatorHandler
  include Interactor

  def call
    SprintCreatorJob.perform_async(context.payload[:sprint_id])
  end
end