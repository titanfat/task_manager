class CreateSprints < ActiveRecord::Migration[7.1]
  def change
    create_table :sprints do |t|
      t.date :start_date, null: false, default: Date.current
      t.date :end_date, null: false, default: Date.current + 2.week
      t.jsonb :settings, null: false, default: {}
      t.timestamps
    end
  end
end
