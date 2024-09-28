# app/controllers/brands_controller.rb
class BrandsController < ApplicationController
  def show
    @brand = Brand.friendly.find(params[:id])
    authorize @brand
  end
end