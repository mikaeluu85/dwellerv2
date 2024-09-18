ActiveAdmin.register Image do
  permit_params :alt_text, :file, :blog_post_id

  index do
    selectable_column
    id_column
    column :alt_text
    column :blog_post
    column :file do |image|
      if image.file.attached?
        image_tag url_for(image.file), size: "50x50"
      else
        'No Image'
      end
    end
    actions
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys

    f.inputs 'Image Details' do
      f.input :blog_post, as: :select, collection: BlogPost.pluck(:title, :id)
      f.input :alt_text
      f.input :file, as: :file
    end

    f.actions
  end

  show do
    attributes_table do
      row :alt_text
      row :blog_post
      row :file do |image|
        if image.file.attached?
          image_tag url_for(image.file)
        else
          'No Image'
        end
      end
    end
    active_admin_comments
  end

  controller do
    include Rails.application.routes.url_helpers
    include ActiveStorage::SetCurrent
  end
end
