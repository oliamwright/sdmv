class CreateVenuePersonValues < ActiveRecord::Migration
  def change
    create_table :venue_person_values do |t|
      t.integer :venue_id
      t.integer :person_value_id
      t.float   :dist
      t.float   :value
    end
  end
end
