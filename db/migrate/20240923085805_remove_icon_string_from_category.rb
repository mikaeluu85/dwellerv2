class RemoveIconStringFromCategory < ActiveRecord::Migration[7.2]
  def change
    remove_column :categories, :icon, :string
  end
end