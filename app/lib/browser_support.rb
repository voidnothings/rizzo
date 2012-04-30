module BrowserSupport

  def is_browser_ie?(user_agent)
    (user_agent).match(/MSIE/) ? true : false
  end

  def is_browser_ie6?(user_agent)
    client_browser(user_agent) === 'ie ie6'
  end

  def is_browser_ie7?(user_agent)
    client_browser(user_agent) === 'ie ie7'
  end

  def is_browser_ie8?(user_agent)
    client_browser(user_agent) === 'ie ie8'
  end

  def is_browser_ie9?(user_agent)
    client_browser(user_agent) === 'ie ie9'
  end

  def is_browser_chrome?(user_agent)
    client_browser(user_agent) === 'chrome'
  end

  def is_browser_safari?(user_agent)
    client_browser(user_agent) === 'safari'
  end

  def is_browser_firefox?(user_agent)
    client_browser(user_agent) === 'firefox'
  end

  def is_browser_opera?(user_agent)
    client_browser(user_agent) === 'opera'
  end

  def is_browser_mobile?(user_agent)
    client_browser(user_agent) === 'mobile'
  end

  def client_browser(user_agent)
    case user_agent
      when /MSIE\s6/ then 'ie ie6'
      when /MSIE\s7/ then 'ie ie7'
      when /MSIE\s8/ then 'ie ie8'
      when /MSIE\s9/ then 'ie ie9'
      when /Chrome/ then 'chrome'
      when /Mobile|Android|WebOS/ then 'mobile'
      when /Safari/ then 'safari'
      when /Opera/ then 'opera'
      when /Firefox/ then 'firefox'
      else 'other'
    end
  end

  def is_client_browser_less_then_ie9?(user_agent)
    is_browser_ie7?(user_agent) || is_browser_ie8?(user_agent)
  end

  def is_client_browser_supported?(user_agent)
    case user_agent
      when /MSIE\s5/, /MSIE\s6/ then false
      else true
    end
  end

  def is_client_browser_unsupported?(user_agent)
    !is_client_browser_supported?(user_agent)
  end

end