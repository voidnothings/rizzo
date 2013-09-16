require "beaker/version"

module Beaker
  module Rails
    class Engine < ::Rails::Engine
      initializer "beaker.configure_rails_initialization" do |app|
      end
    end
  end
end
