class GeospatialService
  def self.point_in_polygon?(point, polygon)
    RGeo::Feature.cast(polygon).contains?(point)
  end

  def self.parse_geojson(geojson)
    RGeo::GeoJSON.decode(geojson)
  end
end
