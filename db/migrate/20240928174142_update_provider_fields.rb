class UpdateProviderFields < ActiveRecord::Migration[7.1]
  def change
    # Remove old fields
    remove_column :providers, :operator_page_description_about, :text
    remove_column :providers, :operator_page_description_why, :text
    remove_column :providers, :is_operator_page_active, :boolean

    # Add new fields
    add_column :providers, :ovid, :string
    add_column :providers, :postal_code, :string
    add_column :providers, :city, :string
    add_column :providers, :invoice_notes, :text
    add_column :providers, :organizational_number, :string
    add_column :providers, :street, :string
    add_column :providers, :invoice_email, :string
    add_column :providers, :woid, :string
    add_column :providers, :website, :string
    add_column :providers, :contact_email, :string
  end
end
