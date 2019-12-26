class CreateMechanics < ActiveRecord::Migration[5.2]
  def change
    create_table :mechanics do |t|
      t.string :name
      t.string :tribe_id, as: :tribal_synergy_id , optional: true
      t.timestamps
    end
  end
end
