Rails.application.routes.draw do
  # Your existing routes
  get "blog_posts/index"
  get "blog_posts/show"
  get "blog_posts/category"
  get "blog_posts/feed"
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :administrators
  root 'home#index'
  
  # ... (rest of your routes)

  # Define routes for error handling
  get '404', to: 'errors#not_found', as: :not_found
  get '500', to: 'errors#internal_server_error', as: :internal_server_error

  # Catch all unmatched routes
  scope '/guider-och-tips' do
    get '/', to: 'blog_posts#index', as: :blog_overview
    get '/:category_slug', to: 'blog_posts#category', as: :blog_category
    get '/:category_slug/:id', to: 'blog_posts#show', as: :blog_article
  end

  # RSS Feed
  get 'feed', to: 'blog_posts#feed', defaults: { format: 'rss' }

  # Modify the catch-all route
  match '*path', to: 'errors#not_found', via: :all, 
    constraints: lambda { |req|
      req.path.exclude?('rails/active_storage') &&
      req.path.exclude?('rails/action_mailbox') &&
      !req.xhr? && req.format.html?
    }
end