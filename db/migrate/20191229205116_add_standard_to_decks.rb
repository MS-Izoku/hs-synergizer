class AddStandardToDecks < ActiveRecord::Migration[5.2]
  def change
    add_column :decks, :standard, :boolean
  end
end
