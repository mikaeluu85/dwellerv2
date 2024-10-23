class MakeBlogPostIdOptionalInImages < ActiveRecord::Migration[7.1]
  def change
    change_column_null :images, :blog_post_id, true
  end
end
