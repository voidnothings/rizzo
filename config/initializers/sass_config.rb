if Gem::Specification.find_by_name("beaker") 
  beaker_path = Gem::Specification.find_by_name("beaker").gem_dir
  [File.join(beaker_path,'app','assets','stylesheets'),File.join(beaker_path,'vendor','assets','stylesheets')].each do |f|
    Rails.application.assets.append_path(f)
  end
  # p 'Beaker assets path exposed to sprockets'
end
#
