class ErrorsController < ApplicationController
  layout 'error'  # Use the error layout

  def not_found
    render_error(404, "Oj, här var det tomt!", "Det verkar som vi inte kan hitta den här sidan.")
  end

  def internal_server_error
    render_error(500, "Nej, något gick fel!", "Vi ber om ursäkt, men något gick fel på servern.")
  end

  private

  def render_error(code, title, message)
    @error_code = code
    @error_title = title
    @error_message = message
    render template: "errors/error_template", status: code
  end
end
