class CountTasks < ActiveRecord::Migration[7.1]
  def change
    add_column :sprints, :tasks_count, :integer
    add_column :projects, :sprints_count, :integer
  end
end
