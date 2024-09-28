class CreateSolutionRooms < ActiveRecord::Migration[7.2]
  def change
    create_table :solution_rooms do |t|
      t.references :solution, null: false, foreign_key: true
      t.references :room, null: false, foreign_key: true

      t.timestamps
    end
  end
end
