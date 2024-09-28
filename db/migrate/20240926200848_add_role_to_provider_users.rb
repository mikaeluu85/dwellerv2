class AddRoleToProviderUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :provider_users, :role, :integer
  end
end
