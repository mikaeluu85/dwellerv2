class RemoveCategoryFromOffersAndEnsureOfferCategoryId < ActiveRecord::Migration[6.1]
  def up
    # Remove the category column
    remove_column :offers, :category, :integer

    # Add offer_category_id column, allowing null values
    add_reference :offers, :offer_category, foreign_key: true, null: true

    # Create a default OfferCategory if it doesn't exist
    default_category = OfferCategory.find_or_create_by!(name: 'Default Category')

    # Update all offers to use the default category
    Offer.where(offer_category_id: nil).update_all(offer_category_id: default_category.id)

    # We're not setting the column to non-nullable here
  end

  def down
    # Add back the category column
    add_column :offers, :category, :integer

    # Remove the offer_category_id column
    remove_reference :offers, :offer_category
  end
end