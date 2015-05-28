class AddMetaFieldsToVenues < ActiveRecord::Migration
  def change
    add_column :venues, :address, :string
    add_column :venues, :category, :string
    add_column :venues, :open_times_from, :time
    add_column :venues, :open_times_to, :time
    add_column :venues, :attendee_count, :integer
    add_column :venues, :contact, :string
    add_column :venues, :booked, :boolean
  end
end
