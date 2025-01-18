# frozen_string_literal: true

class Sprint::SprintOrganizer
  include Interactor::Organizer

  organize Sprint::AddUsers, Sprint::TaskFetch
end