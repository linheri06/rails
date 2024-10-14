class CreateLikes < ActiveRecord::Migration[7.0]
  def change
    create_table :likes do |t|
      t.integer :user_like_id
      t.integer :micropost_like_id

      t.timestamps
    end
  
  add_index :likes, :user_like_id
  add_index :likes, :micropost_like_id
  add_index :likes, [:user_like_id, :micropost_like_id], unique: true
end
end
