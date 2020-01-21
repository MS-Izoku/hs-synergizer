class CreateUserThreads < ActiveRecord::Migration[5.2]
  def change
    create_table :user_threads do |t|
      t.integer :user_id
      t.integer :thread_id

      t.timestamps
    end
  end
end
