require 'kss'
require 'json'

styleguide = Kss::Parser.new('app/assets/stylesheets')

results = []

styleguide.sections.keys.each do |key|

  element = {
      'description' => styleguide.section(key).description,
      'section' => styleguide.section(key).section,
      'filename' => styleguide.section(key).filename
  }

  modifiers = []

  styleguide.section(key).modifiers.each do |value|
    thing = {
        'name' => value.name,
        'description' => value.description
    }
    modifiers.push(thing)
  end

  element['modifiers'] = modifiers

  results.push(element)
end

p results.to_json
