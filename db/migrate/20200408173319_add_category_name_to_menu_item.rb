class AddCategoryNameToMenuItem < ActiveRecord::Migration[6.0]
  def change
    add_column :menu_items, :category_name, :string
  end
end
