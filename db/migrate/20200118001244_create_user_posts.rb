class CreateUserPosts < ActiveRecord::Migration[5.2]
  def change
    create_table :user_posts do |t|
      t.integer :forum_thread_id
      t.integer :user_id

      t.timestamps
    end
  end
end
