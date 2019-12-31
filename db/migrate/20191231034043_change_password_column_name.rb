class ChangePasswordColumnName < ActiveRecord::Migration[5.2]
  def change
    rename_column :users , :password_string , :password_digest
  end
end
