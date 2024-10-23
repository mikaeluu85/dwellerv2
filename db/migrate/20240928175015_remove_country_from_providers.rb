class RemoveCountryFromProviders < ActiveRecord::Migration[7.1]
  def change
    remove_column :providers, :country, :string
  end
end
