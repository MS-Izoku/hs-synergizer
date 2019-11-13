class AddDustCostToCards < ActiveRecord::Migration[5.2]
  def change
    add_column :cards, :dust_cost, :integer
  end
end
