source :rubygems

# Specify your gem's dependencies in rizzo.gemspec
gemspec

gem 'haml'
gem 'rails'
gem 'sass', '3.2.0.alpha.237'
gem 'fozzie', git: 'git@github.com:lonelyplanet/fozzie.git'
gem 'unicorn'
gem 'foreman'
gem 'requirejs-rails'
# jasmine_ci [jasmine 1.2.0 ] requires rspec < 2.11.0 [https://github.com/pivotal/jasmine-gem/issues/94]
gem 'rspec', '< 2.11.0'
# ffi is hanging bundle [https://github.com/carlhuda/bundler/issues/2030]
gem 'ffi', '~> 1.0.11'

group :development do
  gem 'guard-cucumber'
  gem 'guard-rspec'
  gem 'guard-rake'
  gem 'jasmine'
  gem 'headless'
end

group :assets, :cucumber do
  # gem 'avocado', git: 'git@github.com:lonelyplanet/avocado.git'
  gem 'avocado', path:'/Users/dasilaw6/development/lp/lp-muppets/avocado'
  # gem 'beaker', git: 'git@github.com:lonelyplanet/beaker.git'
  gem 'beaker',  path: '/Users/dasilaw6/development/lp/lp-muppets/beaker'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'guard'
  gem 'guard-coffeescript'
  gem 'haml-rails'
  gem 'sass-rails', '~> 3.2.3'
  gem 'uglifier', '>= 1.0.3'
end


