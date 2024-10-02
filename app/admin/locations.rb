ActiveAdmin.register Location do
  menu parent: 'Geo', priority: 2
  permit_params :name, :geojson, :prioritized, :preposition

  controller do
    def find_resource
      if params[:id].to_i.to_s == params[:id]
        scoped_collection.find(params[:id])
      else
        scoped_collection.friendly.find(params[:id])
      end
    end

    def create
      Rails.logger.debug "Params: #{params.inspect}"
      @location = Location.new(permitted_params[:location])
      Rails.logger.debug "Location valid? #{@location.valid?}"
      Rails.logger.debug "Location errors: #{@location.errors.full_messages}" if @location.invalid?

      if @location.save
        begin
          @location.generate_permutations
        rescue => e
          Rails.logger.error "Error generating permutations: #{e.message}"
        end
        redirect_to admin_location_path(@location), notice: 'Location was successfully created.'
      else
        flash.now[:error] = 'Failed to create location.'
        render :new
      end
    end
  end

  index do
    selectable_column
    id_column
    column :name
    column :slug
    column :geojson
    column :prioritized
    column :preposition
    actions
  end

  form do |f|
    f.inputs 'Location Details' do
      f.input :name
      f.input :geojson, as: :text, input_html: { rows: 10 }, hint: 'Paste valid GeoJSON data here'
      f.input :prioritized, as: :boolean
      f.input :preposition, as: :select, collection: [['i', 'i'], ['på', 'på']], include_blank: true
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
      row :preposition
      row :created_at
      row :updated_at
    end
  end

  filter :id
  filter :name
  filter :created_at
  filter :updated_at
  filter :prioritized
  filter :preposition
end