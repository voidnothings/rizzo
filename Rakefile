
require 'find'
require 'rake/clean'
require 'guard'

CLOBBER.include('public/assets/javascripts/lib')

desc 'Compile CoffeeScript files to JavaScript'
task :compile => [:clobber] do
  Guard.setup
  Guard::Dsl.evaluate_guardfile(:guardfile => 'Guardfile')
  Guard.guards(:group => :assets).each{|g| g.run_all()}
end

# default jasmine init task
begin
  require 'jasmine'
  load 'jasmine/tasks/jasmine.rake'
rescue LoadError
  task :jasmine do
    abort "Jasmine is not available. In order to run jasmine, you must: (sudo) gem install jasmine"
  end
end

desc 'clean, compile coffescript, run jasmine:ci'
task :jasmine_ccci=>[:clobber, :compile, 'jasmine:ci']

