class CreateDeckMechanics < ActiveRecord::Migration[5.2]
  def change
    create_table :deck_mechanics do |t|
      t.integer :mechanic_id
      t.integer :deck_id

      t.timestamps
    end
  end
end
