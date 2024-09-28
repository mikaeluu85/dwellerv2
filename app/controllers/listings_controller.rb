# app/controllers/listings_controller.rb
class ListingsController < ApplicationController
  def show
    @listing = Listing.friendly.find(params[:id])
    authorize @listing
  end
end