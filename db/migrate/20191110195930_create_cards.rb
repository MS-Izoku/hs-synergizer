class CreateCards < ActiveRecord::Migration[5.2]
  def change
    create_table :cards do |t|
      t.string :name
      t.integer :card_set_id
      t.integer :player_class_id
      t.integer :tribe_id
      t.integer :cost
      t.integer :health
      t.integer :attack
      t.text :card_text
      t.text :flavor_text
      t.integer :artist_id
      t.boolean :elite
      t.string :player_class
      t.string :img
      t.string :img_gold

      t.timestamps
    end
  end
end
