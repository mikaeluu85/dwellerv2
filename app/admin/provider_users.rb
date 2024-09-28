ActiveAdmin.register ProviderUser do 
  menu parent: 'Customers', priority: 4
  permit_params :email, :first_name, :last_name, :mobile_phone, :role, :provider_id

  scope :all, default: true
  scope :active, -> { where(deleted_at: nil) }
  scope :deleted, -> { where.not(deleted_at: nil) }

  index do
    selectable_column
    id_column
    column :email
    column :first_name
    column :last_name
    column :mobile_phone
    column :role
    column :provider # Add this line to display the associated provider
    actions
  end

  filter :email
  filter :first_name
  filter :last_name
  filter :mobile_phone
  filter :role
  filter :provider # Add this line to filter by provider
  filter :deleted_at, as: :select, collection: [['Active', nil], ['Deleted', true]]

  form do |f|
    f.semantic_errors # Displays form errors at the top

    f.inputs "Provider User Details" do
      f.input :email
      f.input :first_name
      f.input :last_name
      f.input :mobile_phone
      f.input :role, as: :select, collection: ProviderUser.roles.keys
      f.input :provider, as: :select, collection: Provider.all.collect { |p| [p.name, p.id] } # Dropdown for providers
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
      SecureRandom.hex(10) # Generates a 20-character random string
    end
  end

  # Additional configurations...
end
