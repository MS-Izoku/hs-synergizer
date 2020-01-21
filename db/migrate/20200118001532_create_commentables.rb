class CreateCommentables < ActiveRecord::Migration[5.2]
  def change
    create_table :commentables do |t|
      t.text :comment_body
      t.integer :upvotes, default: 0
      t.integer :user_id

      t.timestamps
    end
  end
end
