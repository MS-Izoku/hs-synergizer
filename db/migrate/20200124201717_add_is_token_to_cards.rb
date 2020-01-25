class AddIsTokenToCards < ActiveRecord::Migration[5.2]
  def change
    add_column :cards , :is_token , :boolean , default: false
  end
end
