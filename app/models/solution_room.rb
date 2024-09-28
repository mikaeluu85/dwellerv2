# app/models/solution_room.rb
class SolutionRoom < ApplicationRecord
  belongs_to :solution
  belongs_to :room
end