if Gem::Specification.find_by_name("avocado") 
  avocado_path = Gem::Specification.find_by_name("avocado").gem_dir
  [File.join(avocado_path,'app','assets','javascripts'),File.join(avocado_path,'vendor','assets','javascripts')].each do |f|
    Rails.application.assets.append_path(f)
  end
  p 'Avocado assets path exposed to sprockets'
end
