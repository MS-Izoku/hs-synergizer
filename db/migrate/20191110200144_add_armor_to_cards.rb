class AddArmorToCards < ActiveRecord::Migration[5.2]
  def change
    add_column :cards, :armor, :integer
  end
end
