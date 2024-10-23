begin
  connection = ActiveRecord::Base.connection

  # First, check if PostGIS extension exists and enable it if needed
  unless connection.extension_enabled?("postgis")
    connection.enable_extension("postgis")
  end

  # Only check version after ensuring PostGIS is enabled
  if connection.extension_enabled?("postgis")
    connection.execute("SELECT PostGIS_Full_Version();")
  end
rescue ActiveRecord::NoDatabaseError
  # Database doesn't exist yet (this will happen during db:create)
rescue PG::UndefinedFunction
  # PostGIS might not be installed on the system
  warn "WARNING: PostGIS functions are not available. Please ensure PostGIS is properly installed on your system."
rescue => e
  warn "WARNING: Error initializing PostGIS: #{e.message}"
end
