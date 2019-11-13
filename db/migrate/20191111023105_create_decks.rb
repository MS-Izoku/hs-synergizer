class CreateDecks < ActiveRecord::Migration[5.2]
  def change
    create_table :decks do |t|
      t.string :name
      t.string :deck_code
      t.integer :creator_id

      t.timestamps
    end
  end
end
