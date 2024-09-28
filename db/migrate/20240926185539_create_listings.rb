class CreateListings < ActiveRecord::Migration[7.2]
  def change
    create_table :listings do |t|
      t.references :brand, null: false, foreign_key: true # Ensure brand cannot be null
      t.integer :size
      t.float :cost_per_m2
      t.float :cost_per_user
      t.float :surface_per_user
      t.text :description
      t.text :description_en
      t.integer :number_of_meeting_rooms
      t.date :opened
      t.boolean :is_premium_listing
      t.string :conference_room_request_email
      t.string :name
      t.string :short_description
      t.string :short_description_en
      t.string :url
      t.string :showing_message
      t.integer :status
      t.integer :source
      t.datetime :deleted_at, index: true
      t.timestamps
    end
  end
end
