avocado_files = ['base','version']

avocado_files.each do |file|
  require File.join('avocado', file)
end

require "avocado/engine" if defined?(Rails)

