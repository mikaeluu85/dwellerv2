RSpec.shared_context "authenticated users" do
  let(:admin_user) { create(:admin_user) }
  let(:provider_user) { create(:provider_user) }

  before do
    sign_in(user) if defined?(user)
  end

  shared_examples "requires authentication" do |http_method, action|
    it "redirects to login page" do
      send(http_method, action)
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
