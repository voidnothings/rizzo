module HostSupport
  def shop_url(path = nil)
    host_with_subdomain_and_path("shop", path)
  end

  def www_url(path = nil)
    host_with_subdomain_and_path("www", path)
  end

  def hotels_url(path = nil)
    host_with_subdomain_and_path("hotels", path)
  end

  def host_with_subdomain_and_path(subdomain, path = nil)
    path.gsub!(/^(?<first_char>[^\/])/, '/\k<first_char>') if path
    "#{host_with_subdomain(subdomain)}#{path}"
  end

  def host_with_subdomain(subdomain = "www")
    "//#{subdomain}.#{host_without_subdomain}"
  end

  #
  # NOTE: this fails with domain name extensions with more
  # than one part e.g. .co.uk
  #
  def host_without_subdomain
    parts = request.host_with_port.split('.').last(2)
    parts.join('.')
  end
end