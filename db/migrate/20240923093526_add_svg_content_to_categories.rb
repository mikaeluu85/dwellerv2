class AddSvgContentToCategories < ActiveRecord::Migration[7.2]
  def change
    add_column :categories, :svg_content, :text
  end
end
