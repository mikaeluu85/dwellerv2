ActiveAdmin.register Category do
  menu parent: 'Blog', priority: 2
  permit_params :name, :active, :svg_content

  filter :name
  filter :created_at
  filter :updated_at
  filter :active

  index do
    selectable_column
    id_column
    column :name
    column :slug
    column :active
    column :svg_content do |category|
      if category.svg_content.present?
        raw category.svg_content.html_safe
      else
        'No SVG Content'
      end
    end
    actions
  end

  form do |f|
    f.inputs 'Category Details' do
      f.input :name
      f.input :svg_content, as: :text, input_html: { rows: 10 }
      f.input :active
    end
    f.actions
  end

  controller do
    include Rails.application.routes.url_helpers
    include ActiveStorage::SetCurrent

    def find_resource
      Category.find_by(id: params[:id]) || Category.friendly.find(params[:id])
    end
  end
end