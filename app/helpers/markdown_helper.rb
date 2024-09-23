module MarkdownHelper
  def markdown(text)
    return '' if text.blank?

    options = {
      filter_html:     false,  # Allow HTML to pass through
      hard_wrap:       true,
      link_attributes: { rel: 'nofollow', target: "_blank" },
      space_after_headers: true,
      fenced_code_blocks: true
    }

    extensions = {
      autolink:           true,
      superscript:        true,
      disable_indented_code_blocks: true,
      tables:             true,
      fenced_code_blocks: true,
      lax_spacing:        true,
      no_intra_emphasis:  true
    }

    renderer = TailwindRenderer.new(options)
    markdown = Redcarpet::Markdown.new(renderer, extensions)

    markdown.render(text).html_safe
  end
end
