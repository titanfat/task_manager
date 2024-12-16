class AddIndexesToTasks < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def change
    add_index :tasks, :title, unique: true, algorithm: :concurrently
    add_index :tasks, [:status, :priority], algorithm: :concurrently
    add_index :tasks, [:status, :priority, :executor_id], order: { priority: :asc  }, algorithm: :concurrently
    add_index :tasks, :tags, using: :gin, algorithm: :concurrently
  end
end
