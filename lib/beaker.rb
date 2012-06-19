require "beaker/version"

module Beaker
  Rails.config.assets.paths << File.expand_path("../framework", __FILE__)
end
