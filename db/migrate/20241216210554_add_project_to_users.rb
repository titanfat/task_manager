class AddProjectToUsers < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def change
    safety_assured { add_reference :users, :project, foreign_key: true, null: false, index: { unique: true, algorithm: :concurrently } }
  end
end
