class AddCoordinatesToAddresses < ActiveRecord::Migration[7.1]
  def change
    add_column :addresses, :latitude, :decimal, precision: 10, scale: 8
    add_column :addresses, :longitude, :decimal, precision: 11, scale: 8
  end
end
