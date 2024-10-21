class AddSpatialIndexToAddressesAgain < ActiveRecord::Migration[7.1]
  def change
    add_index :addresses, :coordinates, using: :gist, name: 'index_addresses_on_coordinates'
  end
end