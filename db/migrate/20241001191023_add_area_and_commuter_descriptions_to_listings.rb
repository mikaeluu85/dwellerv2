class AddAreaAndCommuterDescriptionsToListings < ActiveRecord::Migration[7.1]
  def change
    add_column :listings, :area_description, :text
    add_column :listings, :commuter_description, :text
  end
end
