class RemoveFromToFromModels < ActiveRecord::Migration
  def change
    remove_column :person_values, :from, :datetime
    remove_column :person_values, :to, :datetime

    remove_column :venues, :from, :datetime
    remove_column :venues, :to, :datetime
  end
end
