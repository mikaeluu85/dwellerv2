class PermutationsController < ApplicationController
  before_action :set_permutation, only: [:show]
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  def show
    authorize @permutation
    @premise_type = @permutation.premise_type
    @location = @permutation.location

    # Fetch active listings with active offers filtered by the location's GeoJSON polygon
    @listings = fetch_filtered_active_listings_with_active_offers
    @listings_count = @listings.count

    # Only proceed if there are active listings with active offers
    if @listings_count > 0
      # Set custom data for SEO
      @custom_data = {
        'seo_title' => "Hyra #{@premise_type.name} i #{@location.name} | Dweller",
        'seo_description' => "Hitta och hyr #{@premise_type.name} i #{@location.name}. Utforska vårt urval av #{@premise_type.name.pluralize} och hitta den perfekta platsen för ditt företag."
      }

      respond_to do |format|
        format.html
        format.turbo_stream
      end
    else
      flash[:notice] = "Inga aktiva listningar med aktiva erbjudanden hittades för denna plats."
      redirect_to root_path
    end
  end

  private

  def fetch_filtered_active_listings_with_active_offers
    geojson = ensure_geojson_string(@location.geojson)

    listings = Listing.active.joins(:address)
                      .joins("INNER JOIN offers ON offers.listing_id = listings.id")
                      .where("ST_Covers(ST_SetSRID(ST_GeomFromGeoJSON(?), 4326)::geography, addresses.coordinates)", geojson)
                      .where(offers: { status: :active }) # Use the status enum to filter active offers
                      .includes(:address)
                      .distinct

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
