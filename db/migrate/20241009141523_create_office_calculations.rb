# db/migrate/YYYYMMDDHHMMSS_create_office_calculations.rb
class CreateOfficeCalculations < ActiveRecord::Migration[6.1]
  def change
    create_table :office_calculations do |t|
      t.jsonb :steps_data, null: false, default: {}
      t.references :location, null: false, foreign_key: true
      
      # Step 8 fields
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :company, null: false
      t.string :email, null: false
      t.string :phone, null: false
      t.boolean :terms_acceptance, null: false, default: false

      t.timestamps
    end

    add_index :office_calculations, :steps_data, using: :gin
  end
end