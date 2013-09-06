module ImageHelper

  def safe_image_tag(image_url, opts={}, lazyload)
    return if image_url.blank?
    if lazyload == true
      commented_card_image(image_tag(image_url, opts))
    else
      image_tag(image_url, opts)
    end
  end

  def commented_image_tag(image_url, opts={})
    return if image_url.blank?
    commented_image(image_tag(image_url, opts))
  end

  def commented_image(image)
    html = raw("<div data-img=true>")
    html += raw("<!-- #{image.to_s} -->")
    html += raw("</div>")
    html.html_safe
  end

  def commented_card_image(image)
    html = raw("<div data-uncomment=true>")
    html += raw("<!-- #{image.to_s} -->")
    html += raw("</div>")
    html.html_safe
  end

end