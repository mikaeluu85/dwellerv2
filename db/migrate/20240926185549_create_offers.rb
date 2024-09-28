class CreateOffers < ActiveRecord::Migration[7.2]
  def change
    create_table :offers do |t|
      t.references :listing, null: false, foreign_key: true
      t.string :name
      t.text :description
      t.text :description_en
      t.float :price
      t.string :desk_type
      t.integer :nb_days
      t.boolean :personal
      t.float :area
      t.integer :max_seats
      t.integer :min_seats
      t.json :terms
      t.integer :status
      t.integer :type
      t.integer :category
      t.datetime :deleted_at, index: true
      t.timestamps
    end
  end
end
