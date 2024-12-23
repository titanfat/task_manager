class Api::V1::SprintsController < Api::BaseApiController
  def index
    render json: SprintsRepresenter.new(load_sprints), status: :ok
  end

  def create
    sprint = Sprint.new(sprint_params)
    if sprint.save
      render json: SprintsRepresenter.new(load_sprints), status: :ok
    else
      render errors: { errors: sprint.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def sprint_params
    params.require(:sprint).permit(:start_date, :end_date, :project_id)
  end
  def load_sprint = Sprint.find(params[:id])

  def load_sprints
    Sprint.includes %w[tasks users project]
  end
end