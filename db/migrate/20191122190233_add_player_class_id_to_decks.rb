class AddPlayerClassIdToDecks < ActiveRecord::Migration[5.2]
  def change
    add_column :decks, :player_class_id, :integer , default: false
  end
end
