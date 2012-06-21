# -*- encoding: utf-8 -*-
require File.expand_path('../lib/beaker/version', __FILE__)


Gem::Specification.new do |s|
  s.name        = "beaker"
  s.version     = Beaker::Rails::VERSION
  s.authors     = ["Ian Feather"]
  s.email       = ["info@ianfeather.co.uk"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "beaker"

  s.files = `git ls-files`.split($\)
  # s.files = Dir["{app,lib}/**/*"]
  s.require_paths = ["lib"]

end
