class RemovePlayerClassFromCards < ActiveRecord::Migration[5.2]
  def change
    remove_column :cards, :player_class, :integer
  end
end