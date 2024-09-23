require 'nokogiri'

class Category < ApplicationRecord
    extend FriendlyId
    friendly_id :name, use: :slugged
  
    has_many :blog_posts, dependent: :destroy
  
    validates :name, presence: true, uniqueness: true
    validates :slug, presence: true, uniqueness: true
    validates :active, inclusion: { in: [true, false] }
  
    before_save :sanitize_svg_content

    def svg_with_viewbox
        if svg_content.present?
            svg_doc = Nokogiri::HTML::DocumentFragment.parse(svg_content)
            svg_element = svg_doc.at_css('svg')
            width = svg_element['width'].to_i
            height = svg_element['height'].to_i
            
            # Add viewBox if not present
            svg_element['viewBox'] ||= "0 0 #{width} #{height}"

            svg_doc.to_html
        else
            nil
        end
    end

    def self.ransackable_attributes(auth_object = nil)
      ["created_at", "id", "name", "slug", "updated_at", "active"]
    end

    def self.ransackable_associations(auth_object = nil)
      ["blog_posts"]
    end

    private

    def sanitize_svg_content
      if svg_content.present?
        self.svg_content = Sanitize.fragment(svg_content, elements: ['svg', 'path', 'rect', 'polygon', 'g', 'title'], attributes: { 'svg' => ['fill', 'height', 'width', 'viewBox', 'xmlns', 'stroke'], 'path' => ['fill-rule', 'clip-rule', 'd'], 'polygon' => ['points'], 'rect' => ['x', 'y', 'width', 'height'], 'g' => ['fill', 'fill-rule', 'stroke', 'stroke-width'], 'title' => [] })
      end
    end
end