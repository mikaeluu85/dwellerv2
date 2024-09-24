class AddPrepositionToLocations < ActiveRecord::Migration[7.2]
  def change
    add_column :locations, :preposition, :string
  end
end