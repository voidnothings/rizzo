module LodgingHelper

  def card_style_for_lodging(lodging)
    if lodging[:bookable] && lodging[:description] && lodging[:lp_reviewed]
      'card--small-image card--extended-content'
    elsif lodging[:bookable]
      'card--small-image'
    else
      'card--no-image'
    end
  end  

  def show_neighbourhood_or_place_name(lodging, in_lodging_nearby)
    return if in_lodging_nearby
    nearby_place_name = ''

    if lodging[:neighbourhood]
      nearby_place_name = lodging[:neighbourhood]
    elsif lodging[:place_name]
      nearby_place_name = lodging[:city] || lodging[:place_name]
    end

    nearby_place_name = "#{nearby_place_name} (about #{lodging[:distance_from_place]}km)" if lodging[:distance_from_place]

    haml_tag :p, nearby_place_name, :class => :card__locale unless nearby_place_name.blank?
  end

end
