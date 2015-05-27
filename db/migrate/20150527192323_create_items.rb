class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
    	t.float :x
    	t.float :y
    	t.string :keywords

    	t.timestamps
    end
  end
end
