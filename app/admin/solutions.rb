ActiveAdmin.register Solution do
  menu parent: 'Room solutions', priority: 7
  permit_params :name, :listing_id, :deleted_at, :thumbnail, solution_rooms_attributes: [:id, :room_id, :_destroy]

  scope :all, default: true
  scope :active, -> { where(deleted_at: nil) }
  scope :deleted, -> { where.not(deleted_at: nil) }

  index do
    selectable_column
    id_column
    column :name
    column :listing
    column :thumbnail do |solution|
      image_tag solution.thumbnail.variant(resize: "100x100"), class: "admin-thumbnail" if solution.thumbnail.attached?
    end
    actions
  end

  filter :listing
  filter :created_at
  filter :updated_at

  form do |f|
    f.inputs do
      f.input :listing
      f.input :thumbnail, as: :file
      f.input :deleted_at
    end
    f.inputs "Rooms" do
      f.has_many :solution_rooms, allow_destroy: true do |sr|
        sr.input :room
      end
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :listing
      row :thumbnail do |solution|
        image_tag solution.thumbnail.variant(resize: "200x200"), class: "admin-thumbnail" if solution.thumbnail.attached?
      end
      row :created_at
      row :updated_at
      row :deleted_at
    end
    panel "Rooms" do
      table_for solution.rooms do
        column :id
        column :size
        column :workspaces
      end
    end
  end
end
