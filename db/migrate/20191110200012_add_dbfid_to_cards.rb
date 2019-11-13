class AddDbfidToCards < ActiveRecord::Migration[5.2]
  def change
    add_column :cards, :dbf_id, :integer
  end
end
