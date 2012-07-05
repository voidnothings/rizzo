# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name          = 'avocado'
  s.version       = '0.0.1'
  s.date          = '2012-07-05'
  s.summary       = "LonelyPlanet JS Library"
  s.description   = ""
  s.authors       = ["Anselmo da Silva"]
  s.email         = 'anselmo.da.silva@lonelyplanet.co.uk'
  s.files         = ["lib/avocado.rb"]
  s.require_paths = ["lib"]
  s.homepage      = 'http://rubygems.org/gems/avocado'
  s.add_development_dependency 'jasmine'
  s.add_dependency "railties", ">= 3.2.0", "< 5.0"
end

