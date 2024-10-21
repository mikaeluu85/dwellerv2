class AddUuidToOfficeCalculations < ActiveRecord::Migration[7.2]
  def change
    add_column :office_calculations, :uuid, :string
    add_index :office_calculations, :uuid, unique: true
  end
end
