class RemoveDetailsFromLocations < ActiveRecord::Migration[7.1]
  def change
    remove_column :locations, :introduction, :text
    remove_column :locations, :in_depth_description, :text
    remove_column :locations, :commuter_description, :text
  end
end
