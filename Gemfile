source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.1.0"
# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"
# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"
# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"
# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"
# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"
# Use Tailwind CSS [https://github.com/rails/tailwindcss-rails]
gem "tailwindcss-rails"
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"
# Use Redis adapter to run Action Cable in production
# gem "redis", ">= 4.0.1"

gem "ostruct", "~> 0.6.0" # For Rack Attack

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"
gem "image_processing", "~> 1.2"
# gem "image_processing", "~> 1.2"

# Project dedicated

gem "devise" # Authentication solution for Rails, https://github.com/heartcombo/devise
gem "pundit" # Simple and extensible authorization solution for Ruby on Rails, https://github.com/varvet/pundit
gem "sidekiq" # Background job processing for Ruby, https://github.com/mperham/sidekiq
gem "geocode" # Geocoding library for Ruby, https://github.com/alexreisner/geocoder
gem "aws-sdk-s3" # Amazon S3 SDK for Ruby, https://github.com/aws/aws-sdk-ruby
gem "redis", ">= 4.0.1" # Redis key-value store for Ruby, https://github.com/redis/redis

# Add missing gems
gem "activeadmin" # For admin interface
gem "sassc-rails" # Support for activeadmin
gem "redcarpet" # For Markdown rendering
gem "active_storage_validations" # For image validations
gem "nokogiri" # For parsing and modifying SVG content
gem "sitemap_generator" # For sitemap creation
gem "rss" # For RSS feed (nice to have)
gem "meta-tags" # For SEO meta tags
gem "mini_magick", "~> 4.11"
gem "rails-html-sanitizer" # For sanitizing HTML input
gem "sanitize" # For sanitizing inputs in a flexible way
gem "friendly_id", "~> 5.5.1" # Nice slugs
gem "kaminari" # For pagination
gem "paranoia" # For soft delete
gem "rack-attack" # For rate limiting
gem "postmark-rails" # For sending emails
gem "google_maps_rails" # For Google Maps
gem "geocoder" # For geocoding
gem "activerecord-postgis-adapter", "~> 9.0" # PostGIS adapter
gem "rgeo" # For spatial data types
gem "rgeo-geojson" #

gem "wicked_pdf"
gem "wkhtmltopdf-binary"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  # .env
  gem "dotenv-rails"

  # Best Practices
  gem "rails_best_practices"

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false

  # Use Faker in your seeds file
  gem "faker"

  # Testing frameworks
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "faker"
  gem "debug", platforms: %i[mri windows]
  gem "dotenv-rails"
  gem "brakeman", require: false
  gem "rails_best_practices"
  gem "rubocop-rails-omakase", require: false
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
  gem "rspec-rails"
  gem "rails-controller-testing"
  gem "factory_bot_rails"
  gem "shoulda-matchers"
  gem "database_cleaner-active_record"
  gem "simplecov", require: false
  gem "webmock"
  gem "vcr"
  gem "timecop" # For time-based testing
  gem "rspec-sidekiq" # For testing Sidekiq jobs
  gem "pundit-matchers", "~> 3.1"
end
