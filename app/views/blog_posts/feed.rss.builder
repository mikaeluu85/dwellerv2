xml.instruct!
xml.rss version: "2.0" do
  xml.channel do
    xml.title "Dweller Blog Feed"
    xml.description "Latest posts from Dweller"
    xml.link blog_overview_url

    @blog_posts.each do |post|
      xml.item do
        xml.title post.title
        xml.description post.excerpt
        xml.pubDate post.created_at.to_s(:rfc822)
        xml.link blog_article_url(post.category.slug, post.id)
        xml.guid blog_article_url(post.category.slug, post.id)
      end
    end
  end
end