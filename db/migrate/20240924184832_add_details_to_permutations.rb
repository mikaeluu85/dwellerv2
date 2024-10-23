class AddDetailsToPermutations < ActiveRecord::Migration[7.1]
  def change
    add_column :permutations, :introduction, :text
    add_column :permutations, :in_depth_description, :text
    add_column :permutations, :commuter_description, :text
  end
end
