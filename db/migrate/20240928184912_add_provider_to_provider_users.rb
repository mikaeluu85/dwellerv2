class AddProviderToProviderUsers < ActiveRecord::Migration[7.2]
  def change
    add_reference :provider_users, :provider, foreign_key: true
  end
end