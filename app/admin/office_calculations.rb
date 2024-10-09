# app/admin/office_calculations.rb
ActiveAdmin.register OfficeCalculation do
    permit_params :location_id, :first_name, :last_name, :company, :email, :phone, :terms_acceptance, steps_data: {}

    index do
      selectable_column
      id_column
      column :first_name
      column :last_name
      column :company
      column :email
      column :phone
      column :location
      column :created_at
      actions
    end

    filter :first_name
    filter :last_name
    filter :company
    filter :email
    filter :phone
    filter :location
    filter :created_at

    show do
      attributes_table do
        row :id
        row :first_name
        row :last_name
        row :company
        row :email
        row :phone
        row :location
        row :terms_acceptance
        row :created_at
        row :updated_at
        row :steps_data do |calc|
          begin
            parsed_data = JSON.parse(calc.steps_data.to_json)
            pre { code JSON.pretty_generate(parsed_data) }
          rescue JSON::ParserError => e
            div "Error parsing JSON: #{e.message}"
          end
        end
      end
    end

    form do |f|
      f.inputs "Contact Information" do
        f.input :first_name
        f.input :last_name
        f.input :company
        f.input :email
        f.input :phone
        f.input :location
        f.input :terms_acceptance
      end

      f.inputs "Steps Data" do
        f.input :steps_data, as: :text, input_html: { rows: 10 }
      end

      f.actions
    end

    controller do
      def scoped_collection
        super.includes(:location) # for N+1 query optimization
      end
    end
end