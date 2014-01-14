module AssetHelper

  def smart_stylesheet(stylesheet)
    result = ''
    result += raw("<!--[if (gt IE 8) | (IEMobile)]><!-->")
    result += stylesheet_link_tag "#{stylesheet}", :media => "all"
    result += raw("<!--<![endif]-->")
    result += raw("<!--[if (lt IE 9) & (!IEMobile)]>")
    result += stylesheet_link_tag "#{stylesheet}_ie", :media => "all"
    result += raw("<![endif]-->")
    result.html_safe
  end

  def static_ui_stylesheet (stylesheet, secure)
    if secure
      path = "https://secure.lonelyplanet.com/static-ui/style/#{stylesheet}.css"
    else
      path = "http://static.lonelyplanet.com/static-ui/style/#{stylesheet}.css"
    end
    capture_haml do
      haml_tag(:link, href: "#{path}", media: "screen,projection", rel: 'stylesheet')
    end
  end

  def static_ui_script (script, secure)
    if secure
      path = "https://secure.lonelyplanet.com/static-ui/js/#{script}.js"
    else
      path = "http://static.lonelyplanet.com/static-ui/js/#{script}.js"
    end
    capture_haml do
      haml_tag(:script, src: "#{path}")
    end
  end

  def async_js_path (script_name, opts = {})
    if opts[:mobile]
      asset_path("#{script_name}_mobile.js")
    else
      asset_path("#{script_name}.js")
    end
  end

  # Rails 3 and 4 deal with assets differently
  def normalised_asset_path (asset_name)
    asset_with_digest = asset_path(asset_name)
    asset_with_digest = "/assets/#{asset_with_digest}" unless asset_with_digest[0..7] == "/assets/"
    asset_with_digest
  end

end

