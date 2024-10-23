require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock
  config.configure_rspec_metadata!

  # Filter sensitive data
  config.filter_sensitive_data('<API_KEY>') { ENV['API_KEY'] }

  # Ignore localhost requests
  config.ignore_localhost = true

  # Allow real HTTP connections when VCR is turned off
  config.allow_http_connections_when_no_cassette = true
end
