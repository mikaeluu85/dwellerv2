Geocoder.configure(
  # Geocoding options
  timeout: 3,                 # geocoding service timeout (secs)
  lookup: :google,            # name of geocoding service (symbol)
  api_key: ENV['GOOGLE_MAPS_API_KEY'], # API key for geocoding service
  use_https: true,            # use HTTPS for lookup requests? (if supported)
  # ... other options ...
)
