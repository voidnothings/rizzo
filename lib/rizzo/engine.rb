module Rizzo
  class Engine < Rails::Engine

    initializer "rizzo.configure_rails_initialization" do |app|

      puts 'Loading Rizzo'
# 
#       ActiveSupport.on_load :action_controller do
#         helper Rizzo::LayoutHelper
#       end

      app.routes.prepend do
        match 'global'           => 'global_resources#index'
        match 'global_head'      => 'global_resources#head'
        match 'global_header'    => 'global_resources#header'
        match 'global_footer'    => 'global_resources#footer'
        match 'breadcrumb'       => 'global_resources#breadcrumb'
        match "r/:encrypted_url" => 'redirector#show', :as => :redirector
      end

    end

  end
end
