require 'pundit/rspec'

RSpec.configure do |config|
  config.include Pundit::RSpec::Matchers
end
