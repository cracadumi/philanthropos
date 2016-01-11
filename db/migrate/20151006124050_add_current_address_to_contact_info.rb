class AddCurrentAddressToContactInfo < ActiveRecord::Migration
  def change
    add_column :contact_infos, :current_address, :string
  end
end
