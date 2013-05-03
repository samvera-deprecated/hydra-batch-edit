# -*- encoding: utf-8 -*-
require File.expand_path('../lib/hydra/batch_edit/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Justin Coyne", "Matt Zumwalt"]
  gem.email         = ["justin.coyne@yourmediashelf.com"]
  gem.description   = %q{Rails engine to do batch editing with hydra-head}
  gem.summary       = %q{Rails engine to do batch editing with hydra-head}
  gem.homepage      = "https://github.com/projecthydra/hydra-batch-edit"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "hydra-batch-edit"
  gem.require_paths = ["lib"]
  gem.version       = Hydra::BatchEdit::VERSION

  gem.add_dependency 'blacklight'
  gem.add_dependency 'hydra-collections'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rails'
  gem.add_development_dependency 'rspec-rails'
end
