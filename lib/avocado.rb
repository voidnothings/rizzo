avocado_files = ['base','dependencies','version']

avocado_files.each do |file|
  require File.join('avocado', file)
end

require "rizzo/engine" if defined?(Rails)
# require File.join('avocado', "railtie") if Avocado::Dependencies.rails3?

