class AddIndexSprintsSettings < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def change
    add_index :sprints, :settings, using: :gin, algorithm: :concurrently
  end
end
