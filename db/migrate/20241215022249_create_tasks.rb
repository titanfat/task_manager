class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.text :body
      t.string :status, null: false
      t.references :author, null: false, foreign_key: { to_table: :users }, index: true
      t.references :executor, foreign_key: { to_table: :users }, index: true
      t.integer :lead_time
      t.date :start_date
      t.date :end_date
      t.references :sprint, foreign_key: true, index: true
      t.text :description
      t.jsonb :history, default: {}, null: false
      t.string :tags, array: true, default: [], null: false
      t.integer :priority, default: 0, null: false
      t.timestamps
    end
  end
end
