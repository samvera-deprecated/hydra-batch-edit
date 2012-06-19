module Hydra
  module BatchEdit
    extend ActiveSupport::Autoload
    autoload :SearchService
    autoload :Routes
    autoload :Version
    def self.add_routes(router, options = {})
       Routes.new(router, options).draw
    end
    class Engine < ::Rails::Engine
        # Make rails look at the vendored assets
    end
  end
end
