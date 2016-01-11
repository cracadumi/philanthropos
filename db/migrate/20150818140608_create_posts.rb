class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.text :content
      t.string :picture_url
      t.belongs_to :user, index:true
      t.belongs_to :category, index:true
      t.timestamps null: false
    end
  end
end
