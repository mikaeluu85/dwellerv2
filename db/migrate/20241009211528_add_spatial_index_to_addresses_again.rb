class AddSpatialIndexToAddressesAgain < ActiveRecord::Migration[7.1]
  def change
    # Only add the index if it doesn't exist
    unless index_exists?(:addresses, :coordinates, using: :gist, name: 'index_addresses_on_coordinates')
      add_index :addresses, :coordinates, using: :gist, name: 'index_addresses_on_coordinates'
    end
  end
end
