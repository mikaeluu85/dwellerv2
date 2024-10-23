class AddIndexesForFooterQueries < ActiveRecord::Migration[7.0]
  def change
    add_index :locations, :prioritized
    add_index :permutations, [:premise_type_id, :location_id]
  end
end
