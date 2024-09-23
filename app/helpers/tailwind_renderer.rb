class TailwindRenderer < Redcarpet::Render::HTML
    include Redcarpet::Render::SmartyPants

    def paragraph(text)
      "<p class='mb-4 text-gray-700 leading-relaxed tracking-normal text-base'>#{text}</p>"
    end
  
    def header(text, header_level)
      class_name = case header_level
      when 1
        'text-4xl font-bold mb-6 text-gray-900'
      when 2
        'text-3xl font-semibold mb-5 mt-2 text-gray-800'
      when 3
        'text-2xl font-medium mb-3 text-gray-800'
      else
        'text-xl font-medium mb-2 text-gray-800'
      end
      "<h#{header_level} class='#{class_name}'>#{text}</h#{header_level}>"
    end
  
    def list(contents, list_type)
      tag = list_type == :ordered ? 'ol' : 'ul'
      class_name = list_type == :ordered ? 'list-decimal' : 'list-disc'
      "<#{tag} class='#{class_name} list-inside mb-4 pl-5 text-gray-700'>#{contents}</#{tag}>"
    end
  
    def list_item(text, list_type)
      "<li class='mb-2'>#{text}</li>"
    end
  
    def emphasis(text)
      "<em class='italic'>#{text}</em>"
    end
  
    def double_emphasis(text)
      "<strong class='font-semibold'>#{text}</strong>"
    end
  
    def link(link, title, content)
      "<a href='#{link}' title='#{title}' class='text-dark-grey hover:underline'>#{content}</a>"
    end
  
    def image(link, title, alt_text)
      "<img src='#{link}' title='#{title}' alt='#{alt_text}' class='max-w-full h-auto rounded-lg shadow-md mb-4'>"
    end
  
    def block_html(raw_html)
      if raw_html.start_with?('<div class="blog-faq">')
        inner_renderer = TailwindRenderer.new
        markdown = Redcarpet::Markdown.new(inner_renderer, autolink: true, tables: true)
        parsed_content = markdown.render(raw_html.gsub(/<\/?div.*?>/, ''))
        "<div class='bg-gray-100 p-4 rounded-lg mb-4'>#{parsed_content}</div>"
      else
        raw_html
      end
    end
  end