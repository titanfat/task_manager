# frozen_string_literal: true
require 'dry/events'

class EventBus
  include Dry::Events::Publisher[:global]

  register_event('sprint.created')

  def self.instance
    @instance ||= new
  end
end