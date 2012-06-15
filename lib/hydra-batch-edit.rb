require "hydra/batch_edit/version"
require "hydra/batch_edit/routes"
require "hydra/batch_edit_behavior"

module Hydra
  module BatchEdit
    def self.add_routes(router, options = {})
       Routes.new(router, options).draw
    end
    class Engine < ::Rails::Engine
        # Make rails look at the vendored assets
    end
  end
end
