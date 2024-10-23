class AddSvgContentToCategories < ActiveRecord::Migration[7.1]
  def change
    add_column :categories, :svg_content, :text
  end
end
