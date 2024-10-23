class AddDetailsToLocations < ActiveRecord::Migration[7.1]
  def change
    add_column :locations, :introduction, :text
    add_column :locations, :in_depth_description, :text
    add_column :locations, :commuter_description, :text
  end
end
