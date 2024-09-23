class AddPrioritizedToLocations < ActiveRecord::Migration[7.2]
  def change
    add_column :locations, :prioritized, :boolean, default: false
  end
end