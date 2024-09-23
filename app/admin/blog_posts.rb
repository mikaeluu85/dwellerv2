ActiveAdmin.register BlogPost do
  # Ensure we're using ID for all ActiveAdmin routes
  controller do
    def find_resource
      scoped_collection.find(params[:id])
    end
  end

  # Use ID in all links
  member_action :view, method: :get do
    redirect_to admin_blog_post_path(resource)
  end

  action_item :view, only: :show do
    link_to 'View Blog Post', admin_blog_post_path(resource)
  end

  # Modify the index to use ID in links
  index do
    selectable_column
    id_column
    column :title do |blog_post|
      link_to blog_post.title, admin_blog_post_path(blog_post)
    end
    column :slug
    column :category
    column :admin_user
    column :visible
    column :top_story
    column :created_at
    actions
  end

  # Ensure form submits to the correct path
  form do |f|
    f.semantic_errors *f.object.errors.attribute_names

    f.inputs 'Blog Post Details' do
      f.input :admin_user, label: 'Writer', as: :select, collection: AdminUser.all.collect { |u| [u.email, u.id] }
      f.input :category, as: :select, collection: Category.all.collect { |c| [c.name, c.id] }
      f.input :title
      f.input :slug
      f.input :excerpt
      f.input :meta_description
      f.input :content, as: :text
      f.input :visible
      f.input :top_story
      f.input :featured_image, as: :file
    end

    f.inputs 'Images' do
      f.has_many :images, allow_destroy: true, new_record: true do |img_f|
        img_f.input :file, as: :file, hint: img_f.object.file.attached? ? image_tag(img_f.object.file.variant(resize_to_limit: [100, 100])) : content_tag(:span, 'No image yet')
        img_f.input :alt_text
        if img_f.object.persisted? && img_f.object.file.attached?
          img_f.input :image_url, input_html: { value: rails_blob_url(img_f.object.file, only_path: true), readonly: true }
        end
      end
    end

    f.para 'To include an image in the content, use the following markdown syntax:'
    f.code '![Alt text](Image URL)'

    f.actions do
      f.action :submit
      f.action :cancel, :wrapper_html => { :class => 'cancel' }
    end
  end

  show do
    attributes_table do
      row :title
      row :category
      row :admin_user
      row :excerpt
      row :meta_description
      row :visible
      row :top_story
      row :created_at
      row :updated_at
      row :featured_image do |blog_post|
        if blog_post.featured_image.attached?
          image_tag url_for(blog_post.featured_image)
        end
      end
      row :content do |blog_post|
        render_markdown(blog_post.content).html_safe
      end
    end
    active_admin_comments
  end

  controller do
    include Rails.application.routes.url_helpers
    include ActiveStorage::SetCurrent
    include ActionView::Helpers::SanitizeHelper  # Include the SanitizeHelper module

    helper_method :render_markdown

    def render_markdown(text)
      renderer = Redcarpet::Render::HTML.new(hard_wrap: true)
      options = {
        autolink: true,
        tables: true,
        fenced_code_blocks: true,
        strikethrough: true,
        lax_html_blocks: true,
        space_after_headers: true,
        superscript: true
      }
      markdown = Redcarpet::Markdown.new(renderer, options)
      sanitize(markdown.render(text), tags: %w(p br strong em a h1 h2 h3 h4 h5 h6 ul ol li img blockquote pre code), attributes: %w(href src alt title)).html_safe
    end
  end

  permit_params :title, :content, :excerpt, :meta_description, :visible, :top_story, :category_id, :admin_user_id, :slug, :featured_image,
                images_attributes: [:id, :alt_text, :file, :_destroy]
end
