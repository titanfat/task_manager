class AddProjectToUsers < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!
  def up
    safety_assured { add_reference :users, :project, foreign_key: true, null: true, index: true }

    default_project = Project.first&.id || raise('No projects exists')
    User.update_all(project_id: default_project)

    safety_assured { change_column_null :users, :project_id, false }
  end

  def down
    if column_exists?(:users, :project_id)
      change_column_null :users, :project_id, true
      remove_reference :users, :project, foreign_key: true
    end
  end
end
