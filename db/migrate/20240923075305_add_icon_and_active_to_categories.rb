class AddIconAndActiveToCategories < ActiveRecord::Migration[7.2]
  def change
    add_column :categories, :icon, :string
    add_column :categories, :active, :boolean, default: false
  end
end