require "rizzo/version"
require "rizzo/url_encryptor"

module Rizzo::Assets
  def self.precompile
    ['common_core.css', 'common_core_ie.css', 'common_core_no_font.css', 'common_core_no_font_ie.css', 'common_core_overrides.css', 'common_core_overrides_ie.css', 'common_legacy.css', 'common_legacy_ie.css', 'errbit_notifier.js', 'flamsteed.js', 'omniture/s_code.js', 'prism.js', 'prism.css', 'icons/icons.data.svg.css', 'icons/icons.data.png.css', 'icons/icons.fallback.css', 'fonts.css', 'styleguide.css', 'lonelyplanet_minjs/dist/$.js', 'jquery/jquery-1.7.2.min.js']
  end
end
