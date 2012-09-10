require "beaker/version"

module Beaker
  module Rails
    class Engine < ::Rails::Engine
      initializer "beaker.configure_rails_initialization" do |app|
        # your init code goes here
      end
    end
  end
end
