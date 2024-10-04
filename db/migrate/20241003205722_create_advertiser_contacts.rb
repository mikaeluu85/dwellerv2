class CreateAdvertiserContacts < ActiveRecord::Migration[7.0]
  def change
    create_table :advertiser_contacts do |t|
      t.string :company_name
      t.string :org_number
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.string :email

      t.timestamps
    end
  end
end