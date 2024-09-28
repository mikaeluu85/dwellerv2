class RemovePriceCategoryFromProvider < ActiveRecord::Migration[7.2]
  def change
    remove_column :providers, :price_category, :integer
  end
end