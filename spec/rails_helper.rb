require 'simplecov'

# Configure SimpleCov
SimpleCov.start 'rails' do
  # Configure SimpleCov
  add_filter '/bin/'
  add_filter '/db/'
  add_filter '/test/' # Since you're using RSpec
  add_filter '/config/'
  add_filter '/vendor/'
  add_filter '/spec/spec_helper.rb'

  # Add groups for better organization
  add_group 'Controllers', 'app/controllers'
  add_group 'Models', 'app/models'
  add_group 'Helpers', 'app/helpers'
  add_group 'Libraries', 'lib'
  add_group 'Policies', 'app/policies'

  # Set minimum coverage percentage
  minimum_coverage 90
end
# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
# Uncomment the line below in case you have `--require rails_helper` in the `.rspec` file
# that will avoid rails generators crashing because migrations haven't been run yet
# return unless Rails.env.test?
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!
require 'capybara/rails' # If you plan to write feature specs
require 'pundit/matchers'
require 'pundit/rspec'
require 'devise'
require 'webdrivers'
require 'capybara'
require 'selenium-webdriver'



# Load support files
Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  # Factory Bot configuration
  config.include FactoryBot::Syntax::Methods

  # Database cleaner configuration
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.strategy = :transaction
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  # Devise test helpers
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::ControllerHelpers, type: :view
  config.include Devise::Test::IntegrationHelpers, type: :feature
  config.include Warden::Test::Helpers

  # General RSpec Rails configurations
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  # Include FactoryBot methods
  config.include FactoryBot::Syntax::Methods

  # Configure Shoulda-Matchers
  Shoulda::Matchers.configure do |shoulda_config|
    shoulda_config.integrate do |with|
      with.test_framework :rspec
      with.library :rails
    end
  end

  config.before(:suite) do
    ActiveRecord::Base.connection.enable_extension('postgis') unless ActiveRecord::Base.connection.extension_enabled?('postgis')
  end

  # Include Pundit helpers
  config.include Pundit::Authorization

  # Include Pundit matchers for policy specs
  config.include Pundit::RSpec::Matchers, type: :policy

  config.include Devise::Test::IntegrationHelpers, type: :system
  config.include Warden::Test::Helpers

  config.before(:each, type: :system) do
    driven_by :selenium_chrome_headless
  end

  # Update Capybara configuration for M1/M2 Mac
  Capybara.register_driver :selenium_chrome_headless do |app|
    # Set Chrome binary path explicitly
    chrome_path = '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome'

    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--headless=new')  # Use new headless mode
    options.add_argument('--no-sandbox')
    options.add_argument('--disable-dev-shm-usage')
    options.add_argument('--window-size=1400,1400')
    options.binary = chrome_path

    Capybara::Selenium::Driver.new(
      app,
      browser: :chrome,
      options: options
    )
  end

  # Configure Capybara
  Capybara.configure do |config|
    config.default_driver = :rack_test
    config.javascript_driver = :selenium_chrome_headless
    config.default_max_wait_time = 5
    config.server = :puma, { Silent: true }
  end

  # Disable Webdrivers automatic updates since we're using Homebrew's chromedriver
  Webdrivers::Chromedriver.required_version = File.read('/opt/homebrew/Caskroom/chromedriver/130.0.6723.69/version').strip rescue nil

  config.include ActionDispatch::TestProcess::FixtureFile

  config.include Devise::Test::ControllerHelpers, type: :controller

  # Helper to evaluate ActiveAdmin DSL blocks
  config.before(:each, type: :controller) do
    @routes = Rails.application.routes
  end

  # Update Devise configuration
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::IntegrationHelpers, type: :system
  config.include Devise::Test::IntegrationHelpers, type: :request

  # Make sure Warden is properly configured
  config.include Warden::Test::Helpers

  config.before(:suite) do
    Warden.test_mode!
  end

  config.after(:each) do
    Warden.test_reset!
  end

  # Add this for controller tests
  config.before(:each, type: :controller) do
    @request = ActionController::TestRequest.create(ActionController::Metal.new.class)
  end

  # Replace the ActiveAdmin load! call with proper initialization
  config.before(:suite) do
    # Load Active Admin configuration
    ActiveAdmin.setup do |config|
      config.authentication_method = :authenticate_admin_user!
      config.current_user_method = :current_admin_user
      config.logout_link_path = :destroy_admin_user_session_path
      config.batch_actions = true
    end

    # Reload routes
    Rails.application.reload_routes!
  end
end

# Load all factories
# Dir[Rails.root.join('spec/factories/**/*.rb')].sort.each { |file| require file }

# Add this block at the bottom of the file
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
