class CreateAddresses < ActiveRecord::Migration[7.1]
  def change
    create_table :addresses do |t|
      t.references :listing, null: false, foreign_key: true
      t.string :country
      t.string :city
      t.string :street
      t.string :locator
      t.string :postal_code
      t.string :postal_town

      t.timestamps
    end
  end
end
