ActiveAdmin.register ProviderUser do 
  menu parent: 'Customers', priority: 4
  permit_params :email, :first_name, :last_name, :mobile_phone, :role, :provider_id

  scope :all, default: true
  scope :active, -> { where(deleted_at: nil) }
  scope :deleted, -> { where.not(deleted_at: nil) }

  # Custom collection action for JSON response
  collection_action :json_index, method: :get do
    if params[:brand_id].present?
      brand = Brand.find_by(id: params[:brand_id])
      if brand
        @provider_users = brand.provider.provider_users
        Rails.logger.info "Found #{@provider_users.count} provider users for brand #{brand.name}"
      else
        Rails.logger.error "Brand not found with id #{params[:brand_id]}"
        @provider_users = ProviderUser.none
      end
    else
      Rails.logger.info "No brand_id provided, returning all provider users"
      @provider_users = ProviderUser.all
    end

    render json: @provider_users.map { |pu| { id: pu.id, email: pu.email } }
  end

  index do
    selectable_column
    id_column
    column :email
    column :first_name
    column :last_name
    column :mobile_phone
    column :role
    column :provider
    actions
  end

  filter :email
  filter :first_name
  filter :last_name
  filter :mobile_phone
  filter :role
  filter :provider
  filter :deleted_at, as: :select, collection: [['Active', nil], ['Deleted', true]]

  form do |f|
    f.semantic_errors
    f.inputs "Provider User Details" do
      f.input :email
      f.input :first_name
      f.input :last_name
      f.input :mobile_phone
      f.input :role, as: :select, collection: ProviderUser.roles.keys
      f.input :provider, as: :select, collection: Provider.all.collect { |p| [p.name, p.id] }
    end
    f.actions
  end

  controller do
    def create
      @provider_user = ProviderUser.new(permitted_params[:provider_user])
      @provider_user.password = generate_password
      @provider_user.password_confirmation = @provider_user.password

      if @provider_user.save
        redirect_to admin_provider_user_path(@provider_user), notice: 'Provider User was successfully created.'
      else
        render :new
      end
    end

    private

    def generate_password
      SecureRandom.hex(10)
    end
  end

  # Additional configurations...
end
