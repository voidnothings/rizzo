module ImageHelper

  def safe_image_tag(image_url, image_opts={}, load_opts={})
    return if image_url.blank?
    if load_opts[:lazyload]
      lazyloaded_image_tag(image_tag(image_url, image_opts))
    else
      image_tag(image_url, image_opts)
    end
  end

  def lazyloaded_image_tag(image)
    html = raw("<div data-uncomment=true>")
    html += raw("<!-- #{image.to_s} -->")
    html += raw("</div>")
    html.html_safe
  end

end