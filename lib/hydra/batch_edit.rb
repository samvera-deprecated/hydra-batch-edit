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
      config.autoload_paths += %W(
        #{config.root}/app/controllers/concerns
      )
    end
  end
end
