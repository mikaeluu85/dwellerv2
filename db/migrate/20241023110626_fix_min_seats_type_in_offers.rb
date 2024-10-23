class FixMinSeatsTypeInOffers < ActiveRecord::Migration[7.1]
  def up
    # Step 1: Rename existing column to temporary name
    rename_column :offers, :min_seats, :min_seats_json
    # This preserves all existing data while we create the new column
    
    # Step 2: Create new integer column
    add_column :offers, :min_seats, :integer
    # This adds the correctly-typed column
    
    # Step 3: Data migration
    execute <<-SQL
      UPDATE offers 
      SET min_seats = CAST(min_seats_json::text AS integer)
      WHERE min_seats_json IS NOT NULL
    SQL
    # This converts JSON values to integers:
    # - min_seats_json::text converts JSON to text
    # - CAST(...AS integer) converts text to integer
    # - WHERE clause ensures we only process non-null values
    
    # Step 4: Remove temporary column
    remove_column :offers, :min_seats_json
    # Cleanup: remove the old JSON column
  end

  def down
    # Rollback functionality
    change_column :offers, :min_seats, :json
    # If we need to rollback, convert back to JSON
  end
end