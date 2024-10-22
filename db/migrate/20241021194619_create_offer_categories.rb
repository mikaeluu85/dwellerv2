class CreateOfferCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :offer_categories do |t|
      t.string :name, null: false
      t.timestamps
    end

    add_index :offer_categories, :name, unique: true
  end
end
