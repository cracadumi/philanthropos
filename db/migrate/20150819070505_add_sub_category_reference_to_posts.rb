class AddSubCategoryReferenceToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :subcategory_id, :integer, references: :subcategories
  end
end
