class CreateImages < ActiveRecord::Migration[7.1]
  def change
    create_table :images do |t|
      t.string :alt_text
      t.references :blog_post, null: false, foreign_key: true

      t.timestamps
    end
  end
end
