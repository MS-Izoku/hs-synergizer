class AddDescriptionToMechanics < ActiveRecord::Migration[5.2]
  def change
    add_column :mechanics, :description, :string
  end
end
