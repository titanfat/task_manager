class SprintRepresenter < BaseRepresenter
  collection :to_a, as: :sprints do
    property :id
    property :start_date
    property :end_date
    property :project, getter: ->(_) { project&.name }
    collection :tasks do
      property :id
      property :title
      property :executor, getter: ->(_) { executor&.full_name }
      property :priority
      property :status
      property :author, getter: ->(_) { author&.full_name }
    end
    property :created_at
  end
  property :count, as: :total
end