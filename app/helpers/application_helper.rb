module ApplicationHelper
  def sv_pluralize(word)
    word.to_s.pluralize(:sv)
  end

  module ApplicationHelper
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
  end  

end