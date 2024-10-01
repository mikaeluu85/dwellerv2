# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
AdminUser.find_or_create_by!(email: 'seed@seed.com') do |user|
  user.password = 'password'
  user.password_confirmation = 'password'
end if Rails.env.development?

# Create or find the example admin user
admin_user = AdminUser.find_or_create_by!(email: 'admin@example.com') do |user|
  user.password = 'password123'
  user.password_confirmation = 'password123'
end

categories = ['Coworking', 'Office Design', 'Remote Work', 'Productivity', 'Workplace Culture'].map do |name|
  Category.find_or_create_by!(name: name)
end

# Sample blog post content
blog_posts = [
  {
    title: "The Rise of Coworking Spaces in Urban Areas",
    content: "Coworking spaces have become increasingly popular in urban areas...",
    excerpt: "Explore the growing trend of coworking spaces in cities.",
    meta_description: "Analysis of coworking space trends in urban areas",
    category: categories[0]
  },
  {
    title: "Designing the Perfect Office for Productivity",
    content: "The layout and design of an office can significantly impact productivity...",
    excerpt: "Learn how to design an office that boosts productivity.",
    meta_description: "Tips for designing a productive office space",
    category: categories[1]
  },
  {
    title: "Challenges and Solutions in Remote Work",
    content: "While remote work offers flexibility, it also comes with unique challenges...",
    excerpt: "Discover common remote work challenges and how to overcome them.",
    meta_description: "Addressing challenges in remote work environments",
    category: categories[2]
  },
  {
    title: "Productivity Hacks for the Modern Professional",
    content: "In today's fast-paced work environment, productivity is key...",
    excerpt: "Boost your productivity with these proven techniques.",
    meta_description: "Effective productivity tips for professionals",
    category: categories[3]
  },
  {
    title: "Building a Positive Workplace Culture",
    content: "A positive workplace culture is essential for employee satisfaction and retention...",
    excerpt: "Learn strategies to foster a positive workplace culture.",
    meta_description: "Guide to creating a positive work environment",
    category: categories[4]
  }
]

# Path to the image file
image_path = Rails.root.join('spec', 'fixtures', 'files', 'bromma-header.jpg')

# Create blog posts
blog_posts.each do |post|
  BlogPost.find_or_create_by!(title: post[:title]) do |blog_post|
    blog_post.content = post[:content]
    blog_post.excerpt = post[:excerpt]
    blog_post.meta_description = post[:meta_description]
    blog_post.admin_user = admin_user
    blog_post.category = post[:category]
    blog_post.visible = true
    blog_post.top_story = [true, false].sample # Randomly set as top story

    # Attach the image from spec fixtures
    blog_post.featured_image.attach(io: File.open(image_path), filename: 'bromma-header.jpg', content_type: 'image/jpeg')
  end
end

puts "Seed data created successfully!"

# Clear existing data
puts "Clearing existing data..."
AdminUser.destroy_all
puts "AdminUsers cleared"
begin
  Offer.destroy_all
  puts "Offers cleared"
  Listing.destroy_all
  puts "Listings cleared"
  Brand.destroy_all
  puts "Brands cleared"
  Provider.destroy_all
  puts "Providers cleared"
  # If you have a User model, include it here
  # User.destroy_all
  # puts "Users cleared"
rescue => e
  puts "Error during data clearing: #{e.message}"
end

# Seed Providers
puts "Seeding Providers..."
5.times do |i|
  begin
    Provider.create!(
      name: "Provider #{i+1}",
      description: "Description for Provider #{i+1}",
      ovid: "OVID#{i+1}",
      postal_code: "1234#{i+1}",
      city: "City #{i+1}",
      invoice_notes: "Invoice notes for Provider #{i+1}",
      organizational_number: sprintf('%06d-%04d', rand(1000000), rand(10000)), # Format: XXXXXX-XXXX
      street: "Street #{i+1}",
      invoice_email: "invoice_#{i+1}@example.com",
      woid: "WOID#{i+1}",
      website: "http://provider#{i+1}.com",
      contact_email: "contact_#{i+1}@example.com"
    )
    puts "Created Provider #{i+1}"
  rescue ActiveRecord::RecordInvalid => e
    puts "Failed to create Provider #{i+1}: #{e.message}"
  end
end

# Seed Brands
puts "Seeding Brands..."
Provider.all.each do |provider|
  2.times do |i|
    Brand.create!(
      name: "Brand #{i+1} of #{provider.name}",
      provider: provider
    )
  end
end

# Seed Listings
puts "Seeding Listings..."
Brand.all.each do |brand|
  3.times do |i|
    listing = Listing.create!(
      brand: brand,
      name: "Listing #{i+1} of #{brand.name}",
      size: rand(50..500),
      cost_per_m2: rand(10.0..50.0).round(2),
      cost_per_user: rand(100.0..500.0).round(2),
      surface_per_user: rand(5.0..20.0).round(2),
      description: "Description for Listing #{i+1} of #{brand.name}",
      description_en: "English description for Listing #{i+1} of #{brand.name}",
      number_of_meeting_rooms: rand(1..10),
      opened: Date.today - rand(365).days,
      is_premium_listing: [true, false].sample,
      conference_room_request_email: "conference_#{brand.id}_#{i+1}@example.com",
      short_description: "Short description for Listing #{i+1}",
      short_description_en: "Short English description for Listing #{i+1}",
      url: "http://#{brand.name.downcase.gsub(' ', '')}.com/listing#{i+1}",
      showing_message: "Showing message for Listing #{i+1}",
      status: Listing.statuses.keys.sample,
      source: Listing.sources.keys.sample
    )

    # Create address for the listing
    Address.create!(
      listing: listing,
      country: "Country #{i+1}",
      city: "City #{i+1}",
      street: "Street #{i+1}",
      locator: "Locator #{i+1}",
      postal_code: "PC#{i+1}",
      postal_town: "Postal Town #{i+1}"
    )
  end
end

# Seed Offers
puts "Seeding Offers..."
Listing.all.each do |listing|
  2.times do |i|
    Offer.create!(
      listing: listing,
      name: "Offer #{i+1} for #{listing.name}",
      description: "Description for Offer #{i+1}",
      description_en: "English description for Offer #{i+1}",
      price: rand(50.0..500.0).round(2),
      desk_type: ["Standing", "Sitting", "Adjustable"].sample,
      nb_days: rand(1..30),
      personal: [true, false].sample,
      area: rand(5.0..50.0).round(2),
      max_seats: rand(1..10),
      min_seats: rand(1..5),
      terms: { "term1": "value1", "term2": "value2" },
      status: Offer.statuses.keys.sample,
      offer_type: Offer.offer_types.keys.sample,  # Changed from 'type' to 'offer_type'
      category: Offer.categories.keys.sample
    )
  end
end

puts "Seeding completed!"

# Near the end of your seed file, add this:
puts "Creating AdminUser..."
admin_email = 'admin@example.com'
admin_password = 'password123'

if AdminUser.find_by(email: admin_email)
  puts "AdminUser with email #{admin_email} already exists. Skipping creation."
else
  AdminUser.create!(
    email: admin_email,
    password: admin_password,
    password_confirmation: admin_password
  )
  puts "AdminUser created with email: #{admin_email}"
end