class CreateSearchContactsAndJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_table :search_contacts do |t|
      t.string :company_name
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.string :email
      t.integer :number_of_workspaces
      t.string :office_type

      t.timestamps
    end

    create_join_table :search_contacts, :locations do |t|
      t.index [:search_contact_id, :location_id], name: 'index_search_contacts_locations'
      t.index [:location_id, :search_contact_id], name: 'index_locations_search_contacts'
    end
  end
end