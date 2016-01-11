class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :type
      t.string :content
      t.belongs_to :user, index: true
      t.timestamps null: false
    end
  end
end
