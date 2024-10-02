class AreasController < ApplicationController
    def index
      @locations = Location.includes(permutations: :premise_type).order(:name)
    end
  end