require 'rails_helper'

RSpec.describe 'Sidekiq Configuration' do
  before do
    # Set the Rails environment to development for testing
    allow(Rails).to receive(:env).and_return('development')
    # Load the Sidekiq initializer
    load Rails.root.join('config', 'initializers', 'sidekiq.rb')
  end

  describe 'Server Configuration' do
    it 'configures Sidekiq with the correct Redis URL for development' do
      expected_redis_url = ENV.fetch('SIDEKIQ_DEVELOPMENT_URL', 'redis://:mypassword@localhost:6379/3')
      expect(Sidekiq::Server).to have_received(:configure_server).with(hash_including(redis: { url: expected_redis_url }))
    end
  end

  describe 'Client Configuration' do
    it 'configures Sidekiq client with the correct Redis URL for development' do
      expected_redis_url = ENV.fetch('SIDEKIQ_DEVELOPMENT_URL', 'redis://:mypassword@localhost:6379/3')
      expect(Sidekiq::Client).to have_received(:configure_client).with(hash_including(redis: { url: expected_redis_url }))
    end
  end
end