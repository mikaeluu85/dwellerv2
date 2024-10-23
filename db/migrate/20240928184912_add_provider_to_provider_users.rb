class AddProviderToProviderUsers < ActiveRecord::Migration[7.1]
  def change
    add_reference :provider_users, :provider, foreign_key: true
  end
end
