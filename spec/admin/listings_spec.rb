require 'rails_helper'

RSpec.describe 'Admin Listings', type: :feature do
  let!(:brand) { create(:brand) }
  let!(:listing) { create(:listing, brand: brand) }
  let!(:inactive_listing) { create(:listing, status: :inactive) }

  before do
    # Assuming Devise is used for authentication
    admin_user = create(:admin_user)
    login_as(admin_user, scope: :admin_user)
  end

  describe 'Index Page' do
    it 'displays all listings' do
      visit admin_listings_path
      expect(page).to have_content(listing.name)
      expect(page).to have_content(inactive_listing.name)
    end

    it 'displays correct columns' do
      visit admin_listings_path
      expect(page).to have_content('Name')
      expect(page).to have_content('Status')
      expect(page).to have_content('Source')
    end
  end

  describe 'Show Page' do
    it 'displays listing details' do
      visit admin_listing_path(listing)
      expect(page).to have_content(listing.name)
      expect(page).to have_content(listing.status)
    end

    it 'handles image loading errors gracefully' do
      # Mock the behavior of the main_image to simulate an error
      allow_any_instance_of(Listing).to receive_message_chain(:main_image, :attached?).and_return(true)
      allow_any_instance_of(Listing).to receive_message_chain(:main_image, :url).and_raise(StandardError, 'Image load error')

      visit admin_listing_path(listing)
      expect(page).to have_content('Error loading image: Image load error')
    end
  end

  describe 'Form Page' do
    it 'allows creating a new listing' do
      visit new_admin_listing_path

      fill_in 'Name', with: 'New Listing'
      fill_in 'Slug', with: 'new-listing'
      select 'active', from: 'Status'
      select 'user_generated', from: 'Source'
      select brand.name, from: 'Brand'
      fill_in 'Area description', with: 'Test area description'
      fill_in 'Commuter description', with: 'Test commuter description'
      fill_in 'Conference room request email', with: 'test@example.com'
      fill_in 'Cost per m2', with: '10.0'
      fill_in 'Cost per user', with: '100.0'
      fill_in 'Description', with: 'Test description'
      fill_in 'Description en', with: 'Test description in English'
      check 'Is premium listing'
      fill_in 'Number of meeting rooms', with: '5'
      select '2024', from: 'listing_opened_1i'
      select 'January', from: 'listing_opened_2i'
      select '1', from: 'listing_opened_3i'
      fill_in 'Short description', with: 'Short description'
      fill_in 'Short description en', with: 'Short description in English'
      fill_in 'Showing message', with: 'Showing message'
      fill_in 'Size', with: '100'
      fill_in 'Surface per user', with: '10.0'
      fill_in 'Url', with: 'http://example.com'

      click_button 'Create Listing'

      expect(page).to have_content('Listing was successfully created.')
    end

    it 'allows editing an existing listing' do
      visit edit_admin_listing_path(listing)
      fill_in 'Name', with: 'Updated Listing'
      click_button 'Update Listing'
      expect(page).to have_content('Listing was successfully updated.')
    end
  end

  describe 'Scopes' do
    it 'filters active listings' do
      visit admin_listings_path(scope: 'active')
      expect(page).to have_content(listing.name)
      expect(page).not_to have_content(inactive_listing.name)
    end

    it 'filters inactive listings' do
      visit admin_listings_path(scope: 'inactive')
      expect(page).to have_content(inactive_listing.name)
      expect(page).not_to have_content(listing.name)
    end
  end

  # describe 'Custom Actions' do
  #   it 'updates provider users' do
  #     visit update_provider_users_admin_listings_path(brand_id: brand.id)
  #     expect(page).to have_content('Provider Users updated')
  #   end
  # end
end
