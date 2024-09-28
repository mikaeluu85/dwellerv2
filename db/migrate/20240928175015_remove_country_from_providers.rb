class RemoveCountryFromProviders < ActiveRecord::Migration[7.2]
  def change
    remove_column :providers, :country, :string
  end
end