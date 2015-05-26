class CreatePersonValues < ActiveRecord::Migration
  def change
    create_table :person_values do |t|
      t.float :x
      t.float :y
      t.float :influence
      t.time  :availability_from
      t.time  :availability_to
      t.string :keywords
      t.float :int_lvl

      t.timestamps
    end
  end
end
