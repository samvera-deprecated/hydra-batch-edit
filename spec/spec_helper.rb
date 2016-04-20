ENV["environment"] ||= 'test'
require "bundler/setup"

require 'engine_cart'
EngineCart.load_application!

require 'rspec/rails'
require 'hydra-batch-edit'


RSpec.configure do |config|
  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!
end
