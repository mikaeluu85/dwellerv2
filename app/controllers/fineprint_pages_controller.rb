class FineprintPagesController < ApplicationController
  skip_before_action :authenticate_provider_user!
  skip_after_action :verify_authorized

  def show
    @page_key = params[:page]

    begin
      fineprint_pages_config = load_fineprint_pages_config
      Rails.logger.debug("Fineprint pages config: #{fineprint_pages_config.inspect}")
    rescue => e
      Rails.logger.error("Error loading fineprint pages config: #{e.message}")
      Rails.logger.error(e.backtrace.join("\n"))
      render plain: 'Configuration error', status: :internal_server_error
      return
    end

    if fineprint_pages_config.nil?
      Rails.logger.error("Fineprint pages configuration is nil")
      render plain: 'Configuration error', status: :internal_server_error
      return
    end

    @page_data = fineprint_pages_config[@page_key]

    if @page_data.nil?
      Rails.logger.error("Page data not found for key: #{@page_key}")
      raise ActionController::RoutingError.new('Not Found')
    end

    @content = markdown(@page_data['content'])
  rescue StandardError => e
    Rails.logger.error("Error loading fineprint page: #{e.message}")
    Rails.logger.error(e.backtrace.join("\n"))
    render plain: 'An error occurred while loading the page', status: :internal_server_error
  end

  private

  def load_fineprint_pages_config
    config_path = Rails.root.join('config', 'fineprint_pages.yml')
    if File.exist?(config_path)
      config_file = YAML.load_file(config_path)
      # Om filen innehåller miljöspecifika nycklar
      if config_file.key?(Rails.env)
        config_file[Rails.env]
      else
        config_file
      end
    else
      Rails.logger.error("Configuration file not found at #{config_path}")
      nil
    end
  rescue Psych::SyntaxError => e
    Rails.logger.error("YAML syntax error occurred while loading fineprint_pages.yml: #{e.message}")
    nil
  end

  def markdown(text)
    renderer = Redcarpet::Render::HTML.new(hard_wrap: true, filter_html: true)
    markdown = Redcarpet::Markdown.new(renderer, {})
    markdown.render(text).html_safe
  end
end
