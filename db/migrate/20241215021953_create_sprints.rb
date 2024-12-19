class CreateSprints < ActiveRecord::Migration[7.1]
  def change
    create_table :sprints do |t|
      t.date :start_date, null: false, default: -> { 'CURRENT_DATE' }
      t.date :end_date, null: false, default: -> { "(CURRENT_DATE + INTERVAL '14 days')" }
      t.jsonb :settings, null: false, default: {}
      t.references :project, null: false, foreign_key: true, index: true
      t.timestamps
    end
  end
end
