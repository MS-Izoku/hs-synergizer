class CreateUpvotes < ActiveRecord::Migration[5.2]
  def change
    create_table :upvotes do |t|
      t.references :upvotable, polymorhic: true, foreign_key: true
      t.integer :count

      t.timestamps
    end
  end
end
