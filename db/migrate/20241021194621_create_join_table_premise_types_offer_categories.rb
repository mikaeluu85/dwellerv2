class CreateJoinTablePremiseTypesOfferCategories < ActiveRecord::Migration[6.1]
  def change
    create_join_table :premise_types, :offer_categories do |t|
      t.index [:premise_type_id, :offer_category_id], name: 'index_premise_types_offer_categories'
      t.index [:offer_category_id, :premise_type_id], name: 'index_offer_categories_premise_types'
    end
  end
end
