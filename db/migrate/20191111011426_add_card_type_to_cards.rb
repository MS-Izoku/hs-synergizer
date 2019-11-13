class AddCardTypeToCards < ActiveRecord::Migration[5.2]
  def change
    add_column :cards, :card_type, :string
  end
end
