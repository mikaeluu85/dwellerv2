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
