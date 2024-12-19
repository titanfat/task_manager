class RemoveExcessIndexes < ActiveRecord::Migration[7.1]

  def up
    remove_index :users, name: "index_users_on_uid"
    remove_index :tasks, name: "index_tasks_on_status_and_priority"
  end

  def down
    add_index :users, :uid
    add_index :tasks, [:status, :priority]
  end
end
