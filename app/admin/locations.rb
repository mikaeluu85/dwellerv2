ActiveAdmin.register Location do
  menu parent: 'Geo', priority: 2
  permit_params :name, :geojson, :prioritized

  controller do
    def find_resource
      scoped_collection.find_by(id: params[:id]) || scoped_collection.friendly.find(params[:id])
    end
  end

  index do
    selectable_column
    id_column
    column :name
    column :slug
    column :geojson
    column :prioritized
    actions
  end

  form do |f|
    f.inputs 'Location Details' do
      f.input :name
      f.input :geojson, as: :text, input_html: { rows: 10 }, hint: 'Paste valid GeoJSON data here'
      f.input :prioritized, as: :boolean # Add the prioritized field
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :slug
      row :geojson
      row :prioritized
      row :created_at
      row :updated_at
    end
  end

  filter :id
  filter :name
  filter :created_at
  filter :updated_at
  filter :prioritized # Add filter for prioritized
end