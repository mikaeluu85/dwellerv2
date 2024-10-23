class CreateOfferVersions < ActiveRecord::Migration[7.1]
  def change
    create_table :offer_versions do |t|
      t.references :offer, null: false, foreign_key: true
      t.integer :version_number
      t.json :offer_changes

      t.timestamps
    end
  end
end
