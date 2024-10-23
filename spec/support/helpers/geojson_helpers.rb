module GeojsonHelpers
  def valid_geojson_point
    {
      type: "Feature",
      properties: {},
      geometry: {
        type: "Point",
        coordinates: [ 18.0686, 59.3293 ] # Stockholm coordinates
      }
    }
  end

  def valid_geojson_polygon
    {
      type: "Feature",
      properties: {},
      geometry: {
        type: "Polygon",
        coordinates: [
          [
            [ 18.0686, 59.3293 ],
            [ 18.0786, 59.3293 ],
            [ 18.0786, 59.3393 ],
            [ 18.0686, 59.3393 ],
            [ 18.0686, 59.3293 ]
          ]
        ]
      }
    }
  end
end

RSpec.configure do |config|
  config.include GeojsonHelpers
end
