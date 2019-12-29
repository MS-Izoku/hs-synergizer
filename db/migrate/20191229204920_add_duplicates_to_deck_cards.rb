class AddDuplicatesToDeckCards < ActiveRecord::Migration[5.2]
  def change
    add_column :deck_cards, :duplicates, :boolean
  end
end
