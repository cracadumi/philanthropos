class AddDateModifToUsers < ActiveRecord::Migration
  def change
    add_column :users, :date_modif, :datetime
  end
end
