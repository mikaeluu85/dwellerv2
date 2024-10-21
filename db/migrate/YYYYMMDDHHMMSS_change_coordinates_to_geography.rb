class ChangeCoordinatesToGeography < ActiveRecord::Migration[6.1]
  def up
    execute "ALTER TABLE addresses ALTER COLUMN coordinates TYPE geography(Point, 4326) USING ST_SetSRID(coordinates::geometry, 4326)::geography"
  end

  def down
    execute "ALTER TABLE addresses ALTER COLUMN coordinates TYPE geometry(Point, 4326) USING coordinates::geometry"
  end
end
