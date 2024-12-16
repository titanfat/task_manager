class AddIndexesToUsers < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def change
    add_index :users, :uid, algorithm: :concurrently
    add_index :users, [:first_name, :last_name], algorithm: :concurrently
  end
end
