SitemapGenerator::Sitemap.default_host = 'https://dweller.se'

SitemapGenerator::Sitemap.create do
  add blog_overview_path, priority: 0.7, changefreq: 'daily'

  Category.find_each do |category|
    add blog_category_path(category.slug), priority: 0.6
  end

  BlogPost.where(visible: true).find_each do |post|
    add blog_article_path(post.category.slug, post.id), lastmod: post.updated_at
  end
end