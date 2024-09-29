class PermutationsController < ApplicationController
  skip_before_action :authenticate_provider_user!, only: [:show]

  def show
    @premise_type = PremiseType.friendly.find(params[:premise_type])
    @location = Location.friendly.find(params[:location_name])
    @permutation = Permutation.find_by(location: @location, premise_type: @premise_type)

    # Ensure authorization is performed
    authorize @permutation

    if @permutation.nil?
      render :not_found, status: :not_found
    else
      @custom_data = JSON.parse(@permutation.custom_data) rescue {}
      @location_description = @location.full_description # Use the full description
    end
  end

  private

  def permutation_params
    params.require(:permutation).permit(:name, :introduction, :in_depth_description, :commuter_description, :header_image)
  end

  def set_permutation
    @location = Location.friendly.find(params[:location_name])
    @premise_type = PremiseType.friendly.find(params[:premise_type])
    @permutation = Permutation.find_by(location: @location, premise_type: @premise_type)
  end

  def authorize_permutation
    authorize @permutation
  end
end