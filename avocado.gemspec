# -*- encoding: utf-8 -*-
require File.expand_path('../lib/avocado/version', __FILE__)

Gem::Specification.new do |s|
  s.name          = 'avocado'
  s.date          = '2012-07-05'
  s.summary       = %q{LonelyPlanet JS Library}
  s.description   = %q{Waldorf: What did the avocado think?, Avocado: It's the pits!}
  s.authors       = ["Anselmo da Silva"]
  s.email         = 'anselmo.da.silva@lonelyplanet.co.uk'
  s.files         = ["lib/avocado.rb"]
  s.require_paths = ["lib"]
  s.homepage      = 'http://rubygems.org/gems/avocado'
  s.version       = Avocado::VERSION

  s.add_development_dependency 'jasmine'
  s.add_development_dependency 'rspec', '< 2.11.0'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'guard'
  s.add_development_dependency 'guard-jasmine'
  s.add_development_dependency 'guard-coffeescript'
end

