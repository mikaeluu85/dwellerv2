class CreateBlogPosts < ActiveRecord::Migration[7.1]
  def change
    create_table :blog_posts do |t|
      t.string :title
      t.text :content
      t.text :excerpt
      t.string :meta_description
      t.boolean :visible
      t.boolean :top_story
      t.references :category, null: false, foreign_key: true
      t.references :admin_user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
