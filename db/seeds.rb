# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
AdminUser.create!(email: 'seed@seed.com', password: 'password', password_confirmation: 'password') if Rails.env.development?

# First, ensure you have at least one AdminUser and Category
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