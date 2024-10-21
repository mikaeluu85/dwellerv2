class AddPointColumnToAddresses < ActiveRecord::Migration[7.1]
  def up
    # Check if the coordinates column already exists
    return if column_exists?(:addresses, :coordinates)

    # Add the coordinates column
    add_column :addresses, :coordinates, :st_point, geographic: true

    # Update existing rows
    execute <<-SQL
      UPDATE addresses
      SET coordinates = ST_SetSRID(ST_MakePoint(longitude, latitude), 4326)
      WHERE latitude IS NOT NULL AND longitude IS NOT NULL;
    SQL
  end

  def down
    remove_column :addresses, :coordinates if column_exists?(:addresses, :coordinates)
  end
end