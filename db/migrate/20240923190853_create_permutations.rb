class CreatePermutations < ActiveRecord::Migration[7.2]
  def change
    create_table :permutations do |t|
      t.references :location, null: false, foreign_key: true
      t.references :premise_type, null: false, foreign_key: true
      t.text :custom_data

      t.timestamps
    end
  end
end
