class PermutationsController < ApplicationController
  before_action :set_permutation, only: [ :show ]
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  def show
    authorize @permutation

    @listings_data = fetch_cached_listings_data
    @listings = @listings_data[:listings]
    @listings_count = @listings_data[:count]

    if @listings_count.positive?
      set_seo_data
      respond_to do |format|
        format.html
        format.turbo_stream
      end
    else
      flash[:notice] = t(".no_listings_found")
      redirect_to root_path
    end
  rescue StandardError => e
    Rails.logger.error("Error in PermutationsController#show: #{e.message}")
    raise
  end

  private

  def fetch_cached_listings_data
    cache_key = "permutation/#{@permutation.cache_key}/listings"
    cache_options = {
      expires_in: 1.hour,
      skip_cache: skip_caching?
    }

    Rails.cache.fetch(cache_key, cache_options) do
      listings = fetch_filtered_active_listings_with_active_offers
      {
        listings: listings,
        count: listings.size
      }
    end
  end

  def fetch_filtered_active_listings_with_active_offers
    listing_ids = fetch_listing_ids
    return [] if listing_ids.empty?

    Listing.where(id: listing_ids)
           .includes(:address, :brand,
                    :gallery_images_attachments,
                    :main_image_attachment,
                    offers: :offer_category)
           .active
  end

  def fetch_listing_ids
    Listing.select("DISTINCT listings.id")
           .active
           .joins(:address)
           .joins(:offers)
           .where(listing_location_condition)
           .where(offers: active_offers_conditions)
           .pluck(:id)
  end

  def listing_location_condition
    [ "ST_Covers(ST_SetSRID(ST_GeomFromGeoJSON(?), 4326)::geography, addresses.coordinates)",
     ensure_geojson_string(@location.geojson) ]
  end

  def active_offers_conditions
    {
      status: :active,
      deleted_at: nil,
      offer_category_id: @premise_type.offer_category_ids
    }
  end

  def ensure_geojson_string(geojson)
    geojson.is_a?(String) ? geojson : geojson.to_json
  end

  def set_seo_data
    @custom_data = {
      "seo_title" => t(".seo_title",
                      premise_type: @premise_type.name,
                      location: @location.name),
      "seo_description" => t(".seo_description",
                           premise_type: @premise_type.name,
                           location: @location.name)
    }
  end

  def set_permutation
    cache_key = "permutation/#{params[:premise_type]}/#{params[:location_name]}"

    @permutation = Rails.cache.fetch(cache_key, skip_cache: skip_caching?) do
      find_permutation
    end

    @premise_type = @permutation.premise_type
    @location = @permutation.location
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = t(".permutation_not_found")
    redirect_to root_path
  end

  def find_permutation
    premise_type = PremiseType.friendly.find(params[:premise_type])
    location = Location.friendly.find(params[:location_name])

    Permutation.includes(:premise_type, :location)
               .find_by!(premise_type: premise_type, location: location)
  end

  def skip_caching?
    Rails.env.development? && params[:skip_cache].present?
  end
end
