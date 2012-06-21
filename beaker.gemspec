# -*- encoding: utf-8 -*-
require File.expand_path('../lib/beaker/version', __FILE__)


Gem::Specification.new do |s|
  s.name        = "beaker"
  s.version     = Beaker::Rails::VERSION
  s.authors     = ["Ian Feather"]
  s.email       = ["info@ianfeather.co.uk"]
  s.homepage    = ""
  s.summary     = %q{Providing the Sass framework for Lonely Planet Online}
  s.description = %q{Gem to be inherited by each project to provide access to global style objects}

  s.rubyforge_project = "beaker"

  #s.files = `git ls-files`.split($\)
  s.files = Dir["{app,lib}/**/*"]
  s.require_paths = ["lib"]

end
