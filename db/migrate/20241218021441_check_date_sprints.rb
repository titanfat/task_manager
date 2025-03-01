class CheckDateSprints < ActiveRecord::Migration[7.1]
  def change
    safety_assured do
      add_check_constraint :sprints, "start_date < end_date", name: "check_start_date_before_end_date"
    end
  end
end
