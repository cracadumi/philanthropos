class CreateContactInfos < ActiveRecord::Migration
  def change
    create_table :contact_infos do |t|
      t.string :adresse
      t.string :npa_localite
      t.string :pays
      t.string :tel_home
      t.string :current_postcode
      t.string :current_town
      t.string :current_country
      t.string :tel_natel
      t.belongs_to :user, index: true

      t.timestamps null: false
    end
  end
end
