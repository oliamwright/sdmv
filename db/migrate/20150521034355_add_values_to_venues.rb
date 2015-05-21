class AddValuesToVenues < ActiveRecord::Migration
  def change
  	add_column :venues, :sum_dist, :float
  	add_column :venues, :sum_value, :float
  end
end
