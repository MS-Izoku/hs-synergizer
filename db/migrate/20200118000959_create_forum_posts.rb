class CreateForumPosts < ActiveRecord::Migration[5.2]
  def change
    create_table :forum_posts do |t|
      t.string :title
      t.text :body
      t.integer :upvotes, default: 0
      t.integer :user_id

      t.timestamps
    end
  end
end
