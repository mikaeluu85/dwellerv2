class Address < ApplicationRecord
  belongs_to :listing

  before_save :set_coordinates

  attr_accessor :address_changed

  def coordinates_array
    return nil unless coordinates
    [coordinates.x, coordinates.y]
  end

  def latitude
    coordinates&.y
  end

  def longitude
    coordinates&.x
  end

  def full_address
    [street, city, postal_code].compact.join(', ')
  end

  private

  def set_coordinates
    Rails.logger.info "Setting coordinates for Address ID: #{id || 'new record'}"
    Rails.logger.info "Current coordinates: lat: #{latitude}, lon: #{longitude}, coordinates: #{coordinates}"

    if address_changed?
      Rails.logger.info "Address changed, updating coordinates"
      geocode_address
    elsif latitude.blank? || longitude.blank? || coordinates.blank?
      Rails.logger.info "Coordinates missing, geocoding address"
      geocode_address
    else
      Rails.logger.info "Address unchanged and coordinates present, skipping geocoding"
    end
  end

  def geocode_address
    if street.present? && city.present? && postal_code.present?
      Rails.logger.info "Geocoding address: #{full_address}"
      result = Geocoder.search("#{street}, #{postal_code} #{city}, Sverige").first
      if result
        Rails.logger.info "Geocoding successful. Lat: #{result.latitude}, Lon: #{result.longitude}"
        self.latitude = result.latitude
        self.longitude = result.longitude
        self.coordinates = "POINT(#{result.longitude} #{result.latitude})"
      else
        Rails.logger.warn "Geocoding failed for address: #{full_address}"
      end
    else
      Rails.logger.info "Skipping geocoding due to incomplete address"
    end
  end

  def address_changed?
    street_changed? || city_changed? || postal_code_changed?
  end
end
