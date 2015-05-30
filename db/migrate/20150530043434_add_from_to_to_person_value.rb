class AddFromToToPersonValue < ActiveRecord::Migration
  def change
    add_column :person_values, :from, :datetime
    add_column :person_values, :to, :datetime
  end
end
