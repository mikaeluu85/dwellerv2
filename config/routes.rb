Rails.application.routes.draw do
  get "blog_posts/index"
  get "blog_posts/show"
  get "blog_posts/category"
  get "blog_posts/feed"
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :administrators
  root 'home#index'
  #get "home/index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"

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

  match "*unmatched", to: "errors#not_found", via: :all


end