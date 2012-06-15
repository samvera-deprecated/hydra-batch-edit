# -*- encoding: utf-8 -*-
require File.expand_path('../lib/hydra-batch-edit/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["TODO: Write your name"]
  gem.email         = ["justin.coyne@yourmediashelf.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "hydra-batch-edit"
  gem.require_paths = ["lib"]
  gem.version       = Hydra::Batch::Edit::VERSION
end
