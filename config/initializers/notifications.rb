ActiveSupport::Notifications.subscribe "sprint.created" do |name, start, finish, id, payload|
  Sprint::CreatorHandler.call(payload:)
end