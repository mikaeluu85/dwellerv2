ActiveAdmin.register PremiseType do
  menu parent: 'Settings', priority: 2
  permit_params :name, :slug, offer_category_ids: []

  controller do
    def find_resource
      scoped_collection.find_by(id: params[:id]) || scoped_collection.friendly.find(params[:id])
    end

    def create
      super do |format|
        if resource.persisted?
          format.html { redirect_to admin_premise_type_path(resource) }
        else
          format.html { render :new }
        end
      end
    end
  end

  index do
    selectable_column
    id_column
    column :name
    column :slug
    column :offer_categories do |premise_type|
      premise_type.offer_categories.map(&:name).join(", ")
    end
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :slug
      f.input :offer_categories, as: :check_boxes, collection: OfferCategory.all
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :slug
      row :offer_categories do |premise_type|
        premise_type.offer_categories.map(&:name).join(", ")
      end
      row :created_at
      row :updated_at
    end
  end

  filter :id # Ensure you can filter by ID
  filter :name
  filter :created_at
  filter :updated_at
end
