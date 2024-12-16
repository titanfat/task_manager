class CreateJoinTableSprintsUsers < ActiveRecord::Migration[7.1]
  def change
    create_join_table :sprints, :users do |t|
      t.index [:sprint_id, :user_id], unique: true
      t.index [:user_id, :sprint_id], unique: true

      t.foreign_key :sprints, column: :sprint_id, on_delete: :cascade
      t.foreign_key :users, column: :user_id, on_delete: :cascade
    end
  end
end
