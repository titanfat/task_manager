# frozen_string_literal: true

class DefaultProject < ActiveRecord::Migration[7.1]
  def up
    Project.create!(name: "Default Project")
  end

  def down
    Project.where(name: "Default Project").destroy_all
    raise ActiveRecord::IrreversibleMigration
  end
end
