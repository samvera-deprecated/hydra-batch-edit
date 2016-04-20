require 'rails/generators'

class TestAppGenerator < Rails::Generators::Base
  source_root File.expand_path("../../../../spec/test_app_templates", __FILE__)

  # if you need to generate any additional configuration
  # into the test app, this generator will be run immediately
  # after setting up the application

  def install_engine
    generate 'hydra_batch_edit:install'
  end
  
  def copy_test_models
    copy_file "app/models/sample.rb"
    copy_file "app/models/solr_document.rb"
    copy_file "db/migrate/20111101221803_create_searches.rb"
  end

  # def copy_hydra_config
  #   copy_file "config/initializers/hydra_config.rb"
  # end
end

