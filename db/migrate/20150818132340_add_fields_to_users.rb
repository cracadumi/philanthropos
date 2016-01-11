class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :active, :boolean
    add_column :users, :about, :text
    add_column :users, :ident_activite, :text
    add_column :users, :industry, :string
    add_column :users, :occupation, :string
  end
end
