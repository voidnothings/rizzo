class BeakerRailtie < Rails::Railtie
  initializer 'beaker_init' do |app|
    
    Sass::Plugin.add_template_location File.join(Gem.loaded_specs['beaker'].full_gem_path, '/app/assets/stylesheets')
    
  end
end