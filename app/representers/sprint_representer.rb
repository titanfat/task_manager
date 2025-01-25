class SprintRepresenter < BaseRepresenter
  property :id
  property :project_id
  property :start_date
  property :end_date
  property :settings
  property :created_at
  collection :tasks do
    property :id
    property :title
    property :description
    property :executor, getter: ->(_) { executor&.full_name }
    property :priority
    property :status
    property :author, getter: ->(_) { author&.full_name }
    property :lead_time
    property :start_date
    property :end_date
    property :history
  end
  property :tasks_count
end