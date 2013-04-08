source 'https://rubygems.org'

gem 'rails'
gem 'haml'
gem 'sass'
gem 'haml-rails'
gem 'sass-rails', '~> 3.2.3'
gem 'coffee-rails','3.2.2'
gem 'coffee-script-source', '1.4.0'
gem 'requirejs-rails'
gem 'uglifier', '>= 1.0.3'
gem 'unicorn'
gem 'rake'
gem 'airbrake'

group :assets do 
  gem 'avocado', git: 'git@github.com:lonelyplanet/avocado.git'
  gem 'beaker', git: 'git@github.com:lonelyplanet/beaker.git', ref: '189f0c911d718635bc2fcb3f40da842e89e0c105'
end

group :test do 
  gem 'guard'
  gem 'guard-coffeescript'
  gem 'rspec', '~> 2.10.0'
  gem 'rspec-rails'
  gem 'guard-rspec'

  gem 'selenium-webdriver', '2.26.0'
  gem 'capybara', '< 2.0.0'
  gem 'cucumber'
  gem 'cucumber-rails', :require => false
  gem 'launchy'

  gem 'guard-cucumber'
  gem 'rb-fsevent', '~> 0.9.1'
end
