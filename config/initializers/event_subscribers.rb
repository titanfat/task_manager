require 'event_bus'

Rails.application.config.to_prepare do
  bus = EventBus.instance

  bus.subscribe('sprint.created') do |event|
    SprintCreator::SprintOrganizer.call(event.payload)
  end
end