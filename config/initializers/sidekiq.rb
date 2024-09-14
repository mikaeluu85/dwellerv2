Sidekiq.configure_server do |config|
    redis_url = case Rails.env
                when 'production'
                  ENV.fetch('SIDEKIQ_REDIS_URL_PRODUCTION')
                when 'staging'
                  ENV.fetch('SIDEKIQ_REDIS_URL_STAGING')
                when 'test'
                  ENV.fetch('SIDEKIQ_TEST_URL', 'redis://:mypassword@localhost:6379/4')
                when 'development'
                  ENV.fetch('SIDEKIQ_DEVELOPMENT_URL', 'redis://:mypassword@localhost:6379/3')
                else
                  'redis://localhost:6379/1' # Default fallback, if needed
                end
  
    config.redis = { url: redis_url }
  end
  
  Sidekiq.configure_client do |config|
    redis_url = case Rails.env
                when 'production'
                  ENV.fetch('SIDEKIQ_REDIS_URL_PRODUCTION')
                when 'staging'
                  ENV.fetch('SIDEKIQ_REDIS_URL_STAGING')
                when 'test'
                  ENV.fetch('SIDEKIQ_TEST_URL', 'redis://:mypassword@localhost:6379/4')
                when 'development'
                  ENV.fetch('SIDEKIQ_DEVELOPMENT_URL', 'redis://:mypassword@localhost:6379/3')
                else
                  'redis://localhost:6379/1' # Default fallback, if needed
                end
  
    config.redis = { url: redis_url }
  end