class AddUuidToOfficeCalculations < ActiveRecord::Migration[7.1]
  def change
    add_column :office_calculations, :uuid, :string
    add_index :office_calculations, :uuid, unique: true
  end
end
