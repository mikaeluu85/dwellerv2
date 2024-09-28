class AddDeletedAtToModelsWithSoftDelete < ActiveRecord::Migration[7.2]
  def change
    # Add deleted_at to listings if it doesn't exist
    unless column_exists?(:listings, :deleted_at)
      add_column :listings, :deleted_at, :datetime
      add_index :listings, :deleted_at
    end

    # Add deleted_at to external_listings if it doesn't exist
    unless column_exists?(:external_listings, :deleted_at)
      add_column :external_listings, :deleted_at, :datetime
      add_index :external_listings, :deleted_at
    end

    # Add deleted_at to provider_users if it doesn't exist
    unless column_exists?(:provider_users, :deleted_at)
      add_column :provider_users, :deleted_at, :datetime
      add_index :provider_users, :deleted_at
    end

    # Add deleted_at to solutions if it doesn't exist
    unless column_exists?(:solutions, :deleted_at)
      add_column :solutions, :deleted_at, :datetime
      add_index :solutions, :deleted_at
    end

    # Add deleted_at to brands if it doesn't exist
    unless column_exists?(:brands, :deleted_at)
      add_column :brands, :deleted_at, :datetime
      add_index :brands, :deleted_at
    end

    # Add deleted_at to amenities if it doesn't exist
    unless column_exists?(:amenities, :deleted_at)
      add_column :amenities, :deleted_at, :datetime
      add_index :amenities, :deleted_at
    end

    # Add deleted_at to providers if it doesn't exist
    unless column_exists?(:providers, :deleted_at)
      add_column :providers, :deleted_at, :datetime
      add_index :providers, :deleted_at
    end

    # Add deleted_at to offers if it doesn't exist
    unless column_exists?(:offers, :deleted_at)
      add_column :offers, :deleted_at, :datetime
      add_index :offers, :deleted_at
    end
  end
end