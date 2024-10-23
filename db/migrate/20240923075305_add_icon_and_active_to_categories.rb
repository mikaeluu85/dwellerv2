class AddIconAndActiveToCategories < ActiveRecord::Migration[7.1]
  def change
    add_column :categories, :icon, :string
    add_column :categories, :active, :boolean, default: false
  end
end
