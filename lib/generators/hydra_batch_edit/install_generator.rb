require 'rails/generators'

module HydraBatchEdit
  # Installs hydra-batch-edit into the host application
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    def add_routes
      route "Hydra::BatchEdit.add_routes(self)"
    end

    def inject_assets
      copy_file "batch_edit.scss", "app/assets/stylesheets/batch_edit.scss"
      copy_file "batch_edit.js", "app/assets/javascripts/batch_edit.js"
    end
  end
end
