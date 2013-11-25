module Rizzo
  module UrlValidator
    class InvalidUrl < StandardError; end

    LP_HOST = ENV['APP_HOST'] || 'www.lonelyplanet.com'

    def self.validate(url = "")
      begin
        target = Addressable::URI.heuristic_parse(url)
        target.host = LP_HOST
        target.scheme = (target.scheme == 'http' || target.scheme == 'https') ? target.scheme: 'http'
        target.port = target.scheme == 'https' ? 443 : 80
        target.to_s
      rescue URI::InvalidURIError
        raise InvalidUrl
      end
    end

  end
end
