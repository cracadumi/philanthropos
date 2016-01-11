class AddLatitudeAndLongitudeToContactInfo < ActiveRecord::Migration
  def change
    add_column :contact_infos, :latitude, :float
    add_column :contact_infos, :longitude, :float
  end
end
