ActiveAdmin.register Permutation do
  menu parent: 'Geo', priority: 1
  permit_params :name, :introduction, :in_depth_description, :commuter_description, :header_image

  controller do
    def find_resource
      if params[:id].to_i.to_s == params[:id]
        scoped_collection.find(params[:id])
      else
        premise_type_slug, location_slug = params[:id].split('/')
        premise_type = PremiseType.friendly.find(premise_type_slug)
        location = Location.friendly.find(location_slug)
        scoped_collection.find_by!(premise_type: premise_type, location: location)
      end
    rescue ActiveRecord::RecordNotFound
      raise ActiveRecord::RecordNotFound, "Couldn't find Permutation with 'id'=#{params[:id]}"
    end
  end

  index do
    selectable_column
    id_column
    column :location
    column :premise_type
    column :custom_data
    column :introduction # Display introduction in the index
    column :in_depth_description # Display in-depth description in the index
    column :commuter_description # Display commuter description in the index
    column :header_image do |permutation|
      image_tag permutation.header_image.variant(resize_to_limit: [100, 100]) if permutation.header_image.attached?
    end
    actions
  end

  form do |f|
    f.inputs 'Permutation Details' do
      f.input :location, as: :select, collection: Location.all
      f.input :premise_type, as: :select, collection: PremiseType.all
      f.input :custom_data, as: :text, input_html: { rows: 5 }, hint: 'Add any custom data or metadata (JSON format)'
      f.input :introduction # New field for introduction
      f.input :in_depth_description # New field for in-depth description
      f.input :commuter_description # New field for commuter description
      f.input :header_image, as: :file # New field for header image
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :location
      row :premise_type
      row :custom_data
      row :created_at
      row :updated_at
      row :introduction # New field for introduction
      row :in_depth_description # New field for in-depth description
      row :commuter_description # New field for commuter description
      row :header_image do |permutation|
        image_tag permutation.header_image.variant(resize_to_limit: [100, 100]) if permutation.header_image.attached?
      end
    end
  end

  filter :id # Ensure you can filter by ID
  filter :location
  filter :premise_type
  filter :created_at
  filter :updated_at
end