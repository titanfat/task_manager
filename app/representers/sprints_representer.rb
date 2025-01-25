class SprintsRepresenter < BaseRepresenter
  collection :to_a, as: :sprints, decorator: SprintRepresenter
  property :count, as: :total
end