class PermutationsController < ApplicationController
  before_action :set_permutation, only: [:show]
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  def show
    authorize @permutation
    @premise_type = @permutation.premise_type
    @location = @permutation.location

    # Fetch listings filtered by the location's GeoJSON polygon
    @listings = fetch_filtered_listings
    @listings_count = @listings.count

    # Set custom data for SEO
    @custom_data = {
      'seo_title' => "Hyra #{@premise_type.name} i #{@location.name} | Dweller",
      'seo_description' => "Hitta och hyr #{@premise_type.name} i #{@location.name}. Utforska vårt urval av #{@premise_type.name.pluralize} och hitta den perfekta platsen för ditt företag."
    }

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  private

  def fetch_filtered_listings
    geojson = ensure_geojson_string(@location.geojson)

    listings = Listing.joins(:address)
                      .where("ST_Covers(ST_SetSRID(ST_GeomFromGeoJSON(?), 4326)::geography, addresses.coordinates)", geojson)
                      .includes(:address) # Eager load to avoid N+1 queries

    listings.presence || Listing.none # Return an empty relation if no listings found
  end

  def ensure_geojson_string(geojson)
    case geojson
    when String
      geojson
    when Hash, Array
      geojson.to_json
    else
      raise ArgumentError, "Invalid GeoJSON format: #{geojson.class}"
    end
  end

  def permutation_params
    params.require(:permutation).permit(:name, :introduction, :in_depth_description, :commuter_description, :header_image)
  end

  def set_permutation
    @premise_type = PremiseType.friendly.find(params[:premise_type])
    @location = Location.friendly.find(params[:location_name])
    @permutation = Permutation.find_by!(premise_type: @premise_type, location: @location)
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "Permutation not found for the given premise type and location."
    redirect_to root_path
  end
end
