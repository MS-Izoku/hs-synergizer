class CreatePostUpvotes < ActiveRecord::Migration[5.2]
  def change
    create_table :post_upvotes do |t|
      t.integer :post_id
      t.integer :forum_post_id

      t.timestamps
    end
  end
end
