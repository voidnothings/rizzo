if Gem::Specification.find_by_name("beaker") 
  avocado_path = Gem::Specification.find_by_name("beaker").gem_dir
  [File.join(avocado_path,'app','assets','stylesheets'),File.join(avocado_path,'vendor','assets','stylesheets')].each do |f|
    Rails.application.assets.append_path(f)
  end
  # p 'Beaker assets path exposed to sprockets'
end
#
