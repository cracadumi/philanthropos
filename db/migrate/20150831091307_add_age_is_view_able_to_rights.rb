class AddAgeIsViewAbleToRights < ActiveRecord::Migration
  def change
    add_column :rights, :age_is_viewable, :int, default: 0
  end
end
