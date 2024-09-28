class SolutionsController < ApplicationController
  before_action :set_solution, only: [:show, :edit, :update, :destroy]

  def new
    @solution = Solution.new
    @solution.solution_rooms.build # Initialize at least one solution_room
  end

  def create
    @solution = Solution.new(solution_params)
    if @solution.save
      redirect_to @solution, notice: 'Solution was successfully created.'
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @solution.update(solution_params)
      redirect_to @solution, notice: 'Solution was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @solution.destroy
    redirect_to solutions_url, notice: 'Solution was successfully destroyed.'
  end

  private

  def set_solution
    @solution = Solution.find(params[:id])
  end

  def solution_params
    params.require(:solution).permit(:name, :listing_id, :deleted_at, :thumbnail, solution_rooms_attributes: [:id, :room_id, :_destroy])
  end
end
