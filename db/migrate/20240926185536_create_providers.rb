class CreateProviders < ActiveRecord::Migration[7.1]
  def change
    create_table :providers do |t|
      t.string :name
      t.string :country
      t.text :description
      t.text :description_en
      t.integer :price_category
      t.date :founding_date
      t.string :subscription
      t.boolean :is_operator_page_active
      t.text :operator_page_description_about
      t.text :operator_page_description_about_en
      t.text :operator_page_description_why
      t.text :operator_page_description_why_en
      t.datetime :deleted_at, index: true
      t.timestamps
    end
  end
end
