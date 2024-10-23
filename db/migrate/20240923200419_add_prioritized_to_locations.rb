class AddPrioritizedToLocations < ActiveRecord::Migration[7.1]
  def change
    add_column :locations, :prioritized, :boolean, default: false
  end
end
