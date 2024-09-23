FactoryBot.define do
    factory :blog_post do
      title { Faker::Lorem.unique.sentence(word_count: 3) }
      content { Faker::Lorem.paragraphs(number: 5).join("\n\n") }
      excerpt { Faker::Lorem.paragraph(sentence_count: 2) }
      meta_description { Faker::Lorem.characters(number: 150) }
      visible { true }
      top_story { false }
      association :admin_user
      association :category
  
      after(:build) do |blog_post|
        blog_post.featured_image.attach(
          io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'bromma-header.jpg')),
          filename: 'bromma-header.jpg',
          content_type: 'image/jpg'
        )
      end
    end
  end