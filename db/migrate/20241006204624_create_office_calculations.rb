class CreateOfficeCalculations < ActiveRecord::Migration[7.1]
  def change
    create_table :office_calculations do |t|
      t.references :location, null: false, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.string :company
      t.string :email
      t.string :phone
      t.boolean :terms_acceptance, default: false
      t.jsonb :steps_data, default: {}
      t.datetime :completed_at

      t.timestamps
    end
  end
end
