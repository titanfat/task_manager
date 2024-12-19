class Api::V1::SprintsController < Api::BaseApiController
  def index
    render json: SprintRepresenter.new(load_sprints), status: :ok
  end

  def create; end

  private

  def load_sprints
    Sprint.includes %w[tasks users project]
  end
end