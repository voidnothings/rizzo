require File.expand_path('../boot', __FILE__)

require "action_controller/railtie"

require 'haml'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module Rizzo
  class Application < Rails::Application

  end
end