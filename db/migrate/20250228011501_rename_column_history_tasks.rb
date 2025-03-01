class RenameColumnHistoryTasks < ActiveRecord::Migration[7.1]
  def change
    safety_assured { rename_column :tasks, :history, :external_history }
  end
end
