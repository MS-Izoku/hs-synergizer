class CreateCardMechanics < ActiveRecord::Migration[5.2]
  def change
    create_table :card_mechanics do |t|
      t.integer :card_id
      t.integer :mechanic_id

      t.timestamps
    end
  end
end
