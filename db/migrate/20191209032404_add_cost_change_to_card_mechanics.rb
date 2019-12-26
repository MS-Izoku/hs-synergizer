class AddCostChangeToCardMechanics < ActiveRecord::Migration[5.2]
  def change
    add_column :card_mechanics, :cost_change, :integer , optional: true
  end
end
