class CreateForumThreads < ActiveRecord::Migration[5.2]
  def change
    create_table :forum_threads do |t|
      t.string :title
      t.text :body
      t.integer :op_id

      t.timestamps
    end
  end
end
