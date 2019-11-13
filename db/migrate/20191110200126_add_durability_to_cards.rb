class AddDurabilityToCards < ActiveRecord::Migration[5.2]
  def change
    add_column :cards, :durability, :integer
  end
end
