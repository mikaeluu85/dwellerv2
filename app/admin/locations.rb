ActiveAdmin.register Location do
  menu parent: 'Geo', priority: 2
  permit_params :name, :geojson, :prioritized, :preposition # Ensure preposition is included in permitted params

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
    column :preposition # Display preposition in the index
    actions
  end

  form do |f|
    f.inputs 'Location Details' do
      f.input :name
      f.input :geojson, as: :text, input_html: { rows: 10 }, hint: 'Paste valid GeoJSON data here'
      f.input :prioritized, as: :boolean # Add the prioritized field
      f.input :preposition, as: :select, collection: [['i', 'i'], ['på', 'på']], include_blank: true # Ensure preposition field is included
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
      row :preposition # Display preposition in the show view
      row :created_at
      row :updated_at
    end
  end

  filter :id
  filter :name
  filter :created_at
  filter :updated_at
  filter :prioritized # Add filter for prioritized
  filter :preposition # Add filter for preposition
end