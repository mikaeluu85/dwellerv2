class CreateSolutions < ActiveRecord::Migration[7.2]
  def change
    create_table :solutions do |t|
      t.references :listing, null: false, foreign_key: true
      t.integer :size
      t.integer :workspaces
      t.float :price
      t.float :original_price
      t.text :description
      t.boolean :is_big_office

      t.timestamps
    end
  end
end
