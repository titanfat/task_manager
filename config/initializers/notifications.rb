ActiveSupport::Notifications.subscribe "sprint.created" do |name, start, finish, id, payload|
  Sprint::SprintOrganizer.call(payload:)
end