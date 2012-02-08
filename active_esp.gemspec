# -*- encoding: utf-8 -*-
require File.expand_path('../lib/active_esp/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Brian Morton"]
  gem.email         = ["bmorton@sdreader.com"]
  gem.description   = %q{Framework and tools for managing email service providers.}
  gem.summary       = %q{ActiveESP is an abstraction library for managing subscribers, campaigns, and other email marketing facilities.  It provides a consistent interface to interact with the numerous ESPs.}
  gem.homepage      = "http://1703india.st/active_esp"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "active_esp"
  gem.require_paths = ["lib"]
  gem.version       = ActiveESP::VERSION
end
