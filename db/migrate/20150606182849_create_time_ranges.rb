class CreateTimeRanges < ActiveRecord::Migration
  def change
    create_table :time_ranges do |t|
      t.references :owner, polymorphic: true, index: true

      t.datetime :from, null: false
      t.datetime :to, null: false

      t.timestamps
    end
  end
end
