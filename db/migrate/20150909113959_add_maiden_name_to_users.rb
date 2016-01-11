class AddMaidenNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :maiden_name, :string
  end
end
