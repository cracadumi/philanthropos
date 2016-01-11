class AddFieldToRight < ActiveRecord::Migration
  def change
    add_column :rights, :address_viewable_by, :integer, default: 0
  end
end
