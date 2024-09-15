# spec/controllers/errors_controller_spec.rb
require 'rails_helper'

RSpec.describe ErrorsController, type: :controller do
  describe 'GET #not_found' do
    it 'renders the not_found template with 404 status' do
      get :not_found

      expect(response).to have_http_status(404)
      expect(response).to render_template('errors/error_template')
      expect(assigns(:error_code)).to eq(404)
      expect(assigns(:error_title)).to eq("Oj, här var det tomt!")
      expect(assigns(:error_message)).to eq("Det verkar som vi inte kan hitta den här sidan.")
    end
  end

  describe 'GET #internal_server_error' do
    it 'renders the internal_server_error template with 500 status' do
      get :internal_server_error

      expect(response).to have_http_status(500)
      expect(response).to render_template('errors/error_template')
      expect(assigns(:error_code)).to eq(500)
      expect(assigns(:error_title)).to eq("Nej, något gick fel!")
      expect(assigns(:error_message)).to eq("Vi ber om ursäkt, men något gick fel på servern.")
    end
  end
end
