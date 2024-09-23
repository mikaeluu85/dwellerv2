class CreatePremiseTypes < ActiveRecord::Migration[7.2]
  def change
    create_table :premise_types do |t|
      t.string :name
      t.string :slug

      t.timestamps
    end
    add_index :premise_types, :slug, unique: true
  end
end
