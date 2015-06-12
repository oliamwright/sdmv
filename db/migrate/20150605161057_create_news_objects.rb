class CreateNewsObjects < ActiveRecord::Migration
  def change
    create_table :news_objects do |t|
      t.float :x
      t.float :y
      t.string :rss
      t.text :news
      t.string :exclusion
      t.string :keywords

      t.timestamps      
    end
  end
end