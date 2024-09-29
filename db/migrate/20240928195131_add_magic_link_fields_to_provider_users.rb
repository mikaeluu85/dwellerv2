class AddMagicLinkFieldsToProviderUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :provider_users, :magic_token, :string
    add_column :provider_users, :magic_token_expires_at, :datetime
    add_column :provider_users, :magic_token_consumed_at, :datetime

    add_index :provider_users, :magic_token, unique: true
  end
end