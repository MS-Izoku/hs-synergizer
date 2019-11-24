class AddFormatToDecks < ActiveRecord::Migration[5.2]
  def change
    add_column :decks, :format_id, :integer
  end
end
