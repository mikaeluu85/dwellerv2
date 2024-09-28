class CreateListingUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :listing_users do |t|
      t.references :listing, null: false, foreign_key: true
      t.references :provider_user, null: false, foreign_key: true
      t.string :role

      t.timestamps
    end
  end
end
