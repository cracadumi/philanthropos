class CreateRights < ActiveRecord::Migration
  def change
    create_table :rights do |t|
      t.integer :email_veiwable_by, default: 0
      t.integer :dob_viewable_by, default: 0
      t.integer :tel_natel_viewable_by, default: 0
      t.belongs_to :user, index: true
      t.timestamps null: false
    end
  end
end
