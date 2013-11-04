unless defined?(Rizzo::Engine)
  require 'airbrake'
  Airbrake.configure do |config|
    config.api_key = '36d0920e6c6f71715141d9fe0a48d589'
    config.host    = 'errbit.lonelyplanet.com'
    config.port    = 3000
    config.secure  = config.port == 443
    config.development_environments = ["development", "custom"]
  end
end