class GoogleMapsService
  def self.generate_map(location)
    coordinates = location.geojson['coordinates'][0][0]
    center = calculate_center(coordinates)

    map_options = {
      center: { lat: center[:lat], lng: center[:lng] },
      zoom: 13,
      styles: map_styles
    }

    polygon_options = {
      strokeColor: '#FFC602',
      strokeOpacity: 0.8,
      strokeWeight: 2,
      fillColor: '#ffffea',
      fillOpacity: 0.35,
      paths: coordinates.map { |coord| { lat: coord[1], lng: coord[0] } }
    }

    map_hash = {
      map_options: map_options,
      polygons: [polygon_options],
      markers: [{
        lat: center[:lat],
        lng: center[:lng],
        title: location.name
      }]
    }

    map_hash
  end

  def self.generate_static_map_url(location)
    center = calculate_center(location.geojson['coordinates'][0][0])
    
    params = {
      center: "#{center[:lat]},#{center[:lng]}",
      zoom: 12,
      size: "640x400",
      scale: 2,
      maptype: "roadmap",
      key: ENV['GOOGLE_MAPS_API_KEY']
    }

    # Simplify the polygon path by reducing the number of points
    coordinates = location.geojson['coordinates'][0][0]
    simplified_coordinates = coordinates.each_slice(5).map(&:first)
    path = simplified_coordinates.map { |coord| "#{coord[1]},#{coord[0]}" }.join('|')
    params[:path] = "color:0xFFC602|fillcolor:0xffffea|weight:2|#{path}"

    # Simplify the styles and fix encoding

    #TODO: Fetch styles from self.map_styles. DRY.

    styles = [
      "feature:administrative|element:labels.text.fill|color:0x6195a0",
      "feature:landscape|element:all|color:0xf2f2f2",
      "feature:landscape|element:geometry.fill|color:0xffffff",
      "feature:poi|element:all|visibility:off",
      "feature:poi.park|element:geometry.fill|color:0xe6f3d6|visibility:on",
      "feature:road|element:all|saturation:-100|lightness:45|visibility:simplified",
      "feature:road.highway|element:all|visibility:simplified",
      "feature:road.highway|element:geometry.fill|color:0xf4d2c5|visibility:simplified",
      "feature:road.highway|element:labels.text|color:0x4e4e4e",
      "feature:road.arterial|element:geometry.fill|color:0xf4f4f4",
      "feature:road.arterial|element:labels.text.fill|color:0x787878",
      "feature:road.arterial|element:labels.icon|visibility:off",
      "feature:transit|element:all|visibility:off",
      "feature:water|element:all|color:0xeaf6f8|visibility:on",
      "feature:water|element:geometry.fill|color:0xeaf6f8"
    ]

    # Construct the URL manually to ensure correct encoding
    base_url = "https://maps.googleapis.com/maps/api/staticmap"
    query_string = params.to_query
    style_string = styles.map { |style| "&style=#{style}" }.join

    "#{base_url}?#{query_string}#{style_string}"
  end

  private

  def self.calculate_center(coordinates)
    lats = coordinates.map { |coord| coord[1] }
    lngs = coordinates.map { |coord| coord[0] }

    {
      lat: (lats.min + lats.max) / 2,
      lng: (lngs.min + lngs.max) / 2
    }
  end

  def self.map_styles
    [
      {
        featureType: "administrative",
        elementType: "labels.text.fill",
        stylers: [{ color: "#6195a0" }]
      },
      {
        featureType: "landscape",
        elementType: "all",
        stylers: [{ color: "#f2f2f2" }]
      },
      {
        featureType: "landscape",
        elementType: "geometry.fill",
        stylers: [{ color: "#ffffff" }]
      },
      {
        featureType: "poi",
        elementType: "all",
        stylers: [{ visibility: "off" }]
      },
      {
        featureType: "poi.park",
        elementType: "geometry.fill",
        stylers: [
          { color: "#e6f3d6" },
          { visibility: "on" }
        ]
      },
      {
        featureType: "road",
        elementType: "all",
        stylers: [
          { saturation: -100 },
          { lightness: 45 },
          { visibility: "simplified" }
        ]
      },
      {
        featureType: "road.highway",
        elementType: "all",
        stylers: [{ visibility: "simplified" }]
      },
      {
        featureType: "road.highway",
        elementType: "geometry.fill",
        stylers: [
          { color: "#f4d2c5" },
          { visibility: "simplified" }
        ]
      },
      {
        featureType: "road.highway",
        elementType: "labels.text",
        stylers: [{ color: "#4e4e4e" }]
      },
      {
        featureType: "road.arterial",
        elementType: "geometry.fill",
        stylers: [{ color: "#f4f4f4" }]
      },
      {
        featureType: "road.arterial",
        elementType: "labels.text.fill",
        stylers: [{ color: "#787878" }]
      },
      {
        featureType: "road.arterial",
        elementType: "labels.icon",
        stylers: [{ visibility: "off" }]
      },
      {
        featureType: "transit",
        elementType: "all",
        stylers: [{ visibility: "off" }]
      },
      {
        featureType: "water",
        elementType: "all",
        stylers: [
          { color: "#eaf6f8" },
          { visibility: "on" }
        ]
      },
      {
        featureType: "water",
        elementType: "geometry.fill",
        stylers: [{ color: "#eaf6f8" }]
      }
    ]
  end
end
