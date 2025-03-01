# frozen_string_literal: true

module SprintCreator
  class SprintOrganizer
    include Interactor::Organizer

    organize SprintCreator::AddUsers, SprintCreator::TaskFetch
  end
end