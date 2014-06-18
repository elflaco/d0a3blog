class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :subcategory_id
      t.integer :user_id
      t.string :title
      t.string :cover
      t.text :body

      t.timestamps
    end
  end
end