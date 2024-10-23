class GeojsonValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    begin
      RGeo::GeoJSON.decode(value)
    rescue RGeo::Error::ParseError, JSON::ParserError
      record.errors.add(attribute, "is not valid GeoJSON")
    end
  end
end
