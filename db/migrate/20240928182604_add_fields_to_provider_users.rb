class AddFieldsToProviderUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :provider_users, :first_name, :string
    add_column :provider_users, :last_name, :string
    add_column :provider_users, :mobile_phone, :string
  end
end
