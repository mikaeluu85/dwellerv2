Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  devise_for :admin_users, controllers: { sessions: 'admin_users/sessions' }
  devise_for :provider_users, controllers: { sessions: 'provider_users/sessions' }
  
  resources :brands, only: [:show]
  resources :listings, only: [:show]

  resources :brands, param: :slug
  
  get "permutations/show"
  # Your existing routes
  get "blog_posts/index"
  get "blog_posts/show"
  get "blog_posts/category"
  get "blog_posts/feed"
  devise_for :administrators
  root 'home#index'

  # Define routes for error handling
  get '404', to: 'errors#not_found', as: :not_found
  get '500', to: 'errors#internal_server_error', as: :internal_server_error

  # Permutations
  get 'hyra/:premise_type/:location_name', to: 'permutations#show', as: 'hyra_permutation'
  resources :permutations, only: [:index, :edit, :update, :destroy]

  # Blog posts
  scope '/guider-och-tips' do
    get '/', to: 'blog_posts#index', as: :blog_overview
    get '/:category_slug', to: 'blog_posts#category', as: :blog_category
    get '/:category_slug/:slug', to: 'blog_posts#show', as: :blog_article
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