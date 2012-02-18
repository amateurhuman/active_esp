# -*- encoding: utf-8 -*-
require File.expand_path('../lib/active_esp/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Brian Morton"]
  gem.email         = ["bmorton@sdreader.com"]
  gem.description   = %q{Framework and tools for managing email service providers.}
  gem.summary       = %q{ActiveESP is an abstraction library for managing subscribers, campaigns, and other email marketing facilities.  It provides a consistent interface to interact with the numerous ESPs.}
  gem.homepage      = "https://github.com/bmorton/active_esp"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "active_esp"
  gem.require_paths = ["lib"]
  gem.version       = ActiveESP::VERSION

  gem.add_runtime_dependency "json", "> 1.4.0"
  gem.add_runtime_dependency "httparty", "~> 0.8.1"
  gem.add_runtime_dependency "activesupport", ">= 3.0.0"
  gem.add_runtime_dependency "shuber-interface", "~> 0.0.4"

  gem.add_development_dependency "rspec", "~> 2.8.0"
  gem.add_development_dependency "factory_girl", "~> 2.5.1"
  gem.add_development_dependency "yard", "~> 0.7.5"
  gem.add_development_dependency "thin", "~> 1.3.1"
  gem.add_development_dependency "redcarpet", "~> 2.1.0"
end