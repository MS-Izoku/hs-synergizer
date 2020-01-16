class AddDuplicatesToDeck < ActiveRecord::Migration[5.2]
  def change
    add_column :decks, :duplicates, :boolean
  end
end
