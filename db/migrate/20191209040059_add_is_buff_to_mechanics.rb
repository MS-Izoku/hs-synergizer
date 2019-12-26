class AddIsBuffToMechanics < ActiveRecord::Migration[5.2]
  def change
    add_column :mechanics, :is_buff, :boolean , default: false, optional: true
  end
end
