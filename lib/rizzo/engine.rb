module Rizzo
  class Engine < Rails::Engine

    initializer "rizzo.configure_rails_initialization" do |app|

      app.config.assets.precompile += ['rizzo.js']

      Sass::Engine::DEFAULT_OPTIONS[:load_paths].tap do |load_paths|
        load_paths << File.expand_path('../../../app/assets/stylesheets', __FILE__)
      end

      app.routes.prepend do
        match 'global_head'    => 'global_resources#head'
        match 'global_header'  => 'global_resources#header'
        match 'global_footer'  => 'global_resources#footer'
        match 'breadcrumb'     => 'global_resources#breadcrumb'
      end

    end

  end
end