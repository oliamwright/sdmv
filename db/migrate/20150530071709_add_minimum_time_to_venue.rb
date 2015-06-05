class AddMinimumTimeToVenue < ActiveRecord::Migration
  def change
    add_column :venues, :minimum_time, :integer, null: false
  end
end
