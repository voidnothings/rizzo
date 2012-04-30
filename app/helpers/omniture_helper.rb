module OmnitureHelper

  # def omniture_params(place, category, thing_to_do)
  #   properties = omniture_properties(place, category, thing_to_do).map do |k, v|
  #     "s.#{k} = \\"#{escape_javascript(v)}\\" ;"
  #   end
  #   properties.join("\\n")
  # end

  # def omniture_properties(place, category, thing_to_do)
  #   output = {
  #     :pageName => page_name(place),
  #     :channel  => 'dest',
  #     :eVar2    => 'dest' }
  #   output.merge!(country_and_region_properties(place, 'prop', 1))
  #   output.merge!(country_and_region_properties(place, 'eVar', 3))
  #   output.merge!(category_and_thing_to_do_properties(category, thing_to_do, 'prop', 7))
  #   output.merge!(category_and_thing_to_do_properties(category, thing_to_do, 'eVar', 12))
  #   output.merge!(bookable_thing_to_do_properties(thing_to_do))
  # end

  # def omniture_tracking_path
  #   if configured? && domain == "lonelyplanet.com"
  #     "omniture/destinations/s_code.js"
  #   else
  #     "omniture/s_code_dev.js"
  #   end
  # end

  # def bookable_thing_to_do_properties(thing_to_do)
  #   if thing_to_do.blank? || !thing_to_do.bookable?
  #     {}
  #   else
  #     {
  #       "products" => "#{thing_to_do.external_id}",
  #       "prop11" => thing_to_do.partner.name,
  #       "eVar7" => thing_to_do.partner.name
  #     }
  #   end
  # end

  # def page_name(place)
  #   hierarchy = place_hierarchy(place)
  #   page_name = "dest : #{hierarchy.first.name}"
  #   page_name << " : #{hierarchy[1].name}" if hierarchy.size > 1
  #   page_name << " : #{hierarchy.last.name}" if hierarchy.size > 2
  #   return page_name
  # end

  # def country_and_region_properties(place, var, counter)
  #   hierarchy = place_hierarchy(place)
  #   output = {
  #     key(var, counter) => "#{hierarchy.first.name}"
  #   }
  #   output[key(var, counter + 1)] = "#{hierarchy[1].name}" if hierarchy.size > 1
  #   output[key(var, counter + 2)] = "#{hierarchy.last.name}" if hierarchy.size > 2
  #   output
  # end

  # def category_and_thing_to_do_properties(category, thing_to_do, var, counter)
  #   category_name = category.display_name == "Sights" ? "Sight" : category.display_name
  #   output = {
  #     key(var, counter)     => "Things To See and Do",
  #     key(var, counter + 1) => category.all? ? "All POIs" : category_name,
  #     key(var, counter + 2) => "#{category.all? ? "All" : category_name} POI #{thing_to_do.blank? ? "Listing" : "Detail"}"
  #   }
  #   output[key(var, counter + 3)] = thing_to_do.name if thing_to_do
  #   output
  # end

  # private

  # def key(var, counter)
  #   "#{var}#{counter}".to_sym
  # end

  # def place_hierarchy(place)
  #   place.ancestors + [ place ]
  # end

end