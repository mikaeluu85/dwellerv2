module SpatialHelpers
  def point_factory
    RGeo::Geographic.spherical_factory(srid: 4326)
  end

  def create_point(longitude, latitude)
    point_factory.point(longitude, latitude)
  end

  def distance_between_points(point1, point2)
    point1.distance(point2)
  end
end

RSpec.configure do |config|
  config.include SpatialHelpers
end
