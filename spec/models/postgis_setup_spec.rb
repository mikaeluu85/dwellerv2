require 'rails_helper'

RSpec.describe 'PostGIS Setup' do
  it 'has PostGIS enabled' do
    enabled = ActiveRecord::Base.connection.extension_enabled?('postgis')
    expect(enabled).to be true
  end

  it 'can perform spatial queries' do
    result = ActiveRecord::Base.connection.execute("SELECT ST_AsText(ST_Point(0,0))")
    expect(result.first['st_astext']).to eq('POINT(0 0)')
  end

  it 'supports geographic data types' do
    result = ActiveRecord::Base.connection.execute("SELECT ST_Distance(
      ST_GeographyFromText('POINT(18.0686 59.3293)'),
      ST_GeographyFromText('POINT(11.9746 57.7089)')
    )")
    expect(result.first['st_distance']).to be_present
  end
end
