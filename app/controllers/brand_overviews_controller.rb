puts "Loading BrandOverviewsController"

class BrandOverviewsController < ApplicationController
  def index
    @brands = Brand.active.includes(:listings).where(listings: { status: :active }).order(:name)
  end
end