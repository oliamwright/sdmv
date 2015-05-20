class CreateVenues < ActiveRecord::Migration
  def change
    create_table :venues do |t|
      t.float :x
      t.float :y

      t.timestamps
    end
  end
end
