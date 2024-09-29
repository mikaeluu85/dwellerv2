Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  devise_for :admin_users, controllers: { sessions: 'admin_users/sessions' }
  devise_for :provider_users, controllers: { sessions: 'provider_users/sessions' }, skip: [:sessions, :passwords, :registrations]
  
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

  # Provider Dashboard Routes
  namespace :provider do
    get 'dashboard', to: 'dashboard#index', as: :dashboard

    # Magic Links Routes
    get 'login', to: 'magic_links#new', as: :new_magic_link
    post 'magic-login', to: 'magic_links#create', as: :create_magic_link
    get 'magic-login/:token', to: 'magic_links#show', as: :magic_link

    resources :listings do
      member do
        delete 'destroy', to: 'listings#destroy'
      end
    end

    resources :offers do
      member do
        delete 'destroy', to: 'offers#destroy'
      end
    end

    resources :brands do
      member do
        delete 'destroy', to: 'brands#destroy'
      end
    end

    resource :settings, only: [:index] do
      patch 'update_profile'
      patch 'update_provider'
      patch 'update_invoice'
    end
  end

  # Define routes for error handling
  get '404', to: 'errors#not_found', as: :not_found
  get '500', to: 'errors#internal_server_error', as: :internal_server_error


  # Modify the catch-all route
  match '*path', to: 'errors#not_found', via: :all, 
    constraints: lambda { |req|
      req.path.exclude?('rails/active_storage') &&
      req.path.exclude?('rails/action_mailbox') &&
      !req.xhr? && req.format.html?
    }

end