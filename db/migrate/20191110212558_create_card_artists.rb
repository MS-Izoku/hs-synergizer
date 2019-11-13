class CreateCardArtists < ActiveRecord::Migration[5.2]
  def change
    create_table :card_artists do |t|
      t.integer :artist_id
      t.integer :card_id

      t.timestamps
    end
  end
end
