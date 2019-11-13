class CreateCardKeywords < ActiveRecord::Migration[5.2]
  def change
    create_table :card_keywords do |t|
      t.integer :card_id
      t.integer :keyword_id

      t.timestamps
    end
  end
end
