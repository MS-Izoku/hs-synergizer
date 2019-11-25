class AddDbfIdToPlayerClasses < ActiveRecord::Migration[5.2]
  def change
    add_column :player_classes, :dbf_id, :integer
  end
end
