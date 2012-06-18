require 'rails/generators'

class TestAppGenerator < Rails::Generators::Base
  source_root File.expand_path("../../../../support", __FILE__)

  # Inject call to Hydra::BatchEdit.add_routes in config/routes.rb
  def inject_routes
    insert_into_file "config/routes.rb", :after => '.draw do' do
      "\n  # Add BatchEdit routes."
      "\n  Hydra::BatchEdit.add_routes(self)"
    end
  end

  def copy_test_models
    copy_file "app/models/sample.rb"
  end
end
