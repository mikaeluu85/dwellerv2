class AddPrepositionToLocations < ActiveRecord::Migration[7.1]
  def change
    add_column :locations, :preposition, :string
  end
end
