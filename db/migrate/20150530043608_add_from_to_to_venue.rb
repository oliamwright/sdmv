class AddFromToToVenue < ActiveRecord::Migration
  def change
    add_column :venues, :from, :datetime
    add_column :venues, :to, :datetime
  end
end
