class AddUserRole < ActiveRecord::Migration[7.1]
  def change
    create_enum :user_role, ["admin", "user", "executor", "editor"]

    add_column :users, :role, :enum, enum_type: :user_role, default: "user", null: false
    rename_column :users, :f_name, :first_name
    rename_column :users, :l_name, :last_name
  end
end
