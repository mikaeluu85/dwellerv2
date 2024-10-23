class RecordRenamedMigrations < ActiveRecord::Migration[7.1]
  def up
    # Record migrations as completed without running them
    migrations = [
      '20241006204626'  # add_bashyra_to_locations - already exists
    ]

    # Get existing migrations
    existing_migrations = connection.select_values("SELECT version FROM schema_migrations")
    missing_migrations = migrations - existing_migrations

    # Only add missing migrations
    missing_migrations.each do |version|
      say "Recording migration #{version} as completed"
      connection.execute("INSERT INTO schema_migrations (version) VALUES ('#{version}')")
    end

    # Verify the column exists for the bashyra migration
    if missing_migrations.include?('20241006204626')
      unless column_exists?(:locations, :bashyra)
        add_column :locations, :bashyra, :decimal, precision: 10, scale: 2
      end
    end
  end

  def down
    migrations = [
      '20241006204626'
    ]

    say "Removing recorded migrations"
    connection.execute("DELETE FROM schema_migrations WHERE version IN ('#{migrations.join("','")}')")
  end

  private

  def say(message)
    puts "== #{message} =="
  end
end
