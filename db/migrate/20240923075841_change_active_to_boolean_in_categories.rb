class ChangeActiveToBooleanInCategories < ActiveRecord::Migration[7.2]
  def change
    change_column :categories, :active, :boolean, default: false
  end
end