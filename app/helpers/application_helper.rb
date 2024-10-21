module ApplicationHelper
  def sv_pluralize(word)
    word.to_s.pluralize(:sv)
  end

  def markdown(text)
    renderer = Redcarpet::Render::HTML.new(hard_wrap: true)
    options = {
      autolink: true,
      tables: true,
      fenced_code_blocks: true,
      strikethrough: true,
      lax_html_blocks: true,
      space_after_headers: true,
      superscript: true
    }
    markdown = Redcarpet::Markdown.new(renderer, options)
    sanitized = sanitize(markdown.render(text), tags: %w(p br strong em a h1 h2 h3 h4 h5 h6 ul ol li img blockquote pre code), attributes: %w(href src alt title))
    sanitized.html_safe
  end

  def get_calculator_cache_data
    cache_key = "office_calculator_#{session[:calculator_id]}"
    Rails.cache.fetch(cache_key) || {}
  end
end