class CreateCardSets < ActiveRecord::Migration[5.2]
  def change
    create_table :card_sets do |t|
      t.string :name
      t.integer :year
      t.boolean :standard , default: false

      t.timestamps
    end
  end
end
