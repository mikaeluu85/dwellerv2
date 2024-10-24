require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Dwellerv2
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Use Sidekiq for background jobs (ActiveJob)
    config.active_job.queue_adapter = :sidekiq
    
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Explicitly set available locales
    config.i18n.available_locales = [:en, :sv]
    
    # Set default locale to Swedish
    config.i18n.default_locale = :sv

    # Fallback to English if Swedish translation is missing
    config.i18n.fallbacks = [:en]

    # Rack::Attack
    config.middleware.use Rack::Attack

  end
end