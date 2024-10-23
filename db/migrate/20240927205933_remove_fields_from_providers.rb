class RemoveFieldsFromProviders < ActiveRecord::Migration[7.1]
  def change
    remove_column :providers, :description_en, :text
    remove_column :providers, :founding_date, :date
    remove_column :providers, :operator_page_description_about_en, :text
    remove_column :providers, :operator_page_description_why_en, :text
    remove_column :providers, :subscription, :string
  end
end
