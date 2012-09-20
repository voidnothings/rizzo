module Rizzo
  class Engine < Rails::Engine

    initializer "rizzo.configure_rails_initialization" do |app|

      app.routes.prepend do
        match 'global' => 'global_resources#index'
        match 'global-head' => 'global_resources#head'
        match 'global-body-header' => 'global_resources#header'
        match 'global-body-footer' => 'global_resources#footer'
        match "r/:encrypted_url" => 'redirector#show', :as => :redirector
      end

    end

  end
end
