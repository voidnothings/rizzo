module Rizzo
  class Engine < Rails::Engine

    initializer "rizzo.configure_rails_initialization" do |app|

      app.routes.prepend do
        match 'breadcrumb'            => 'global_resources#breadcrumb'
        match "r/:encrypted_url" => 'redirector#show', :as => :redirector
      end

    end

  end
end
