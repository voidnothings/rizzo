module Rizzo
  class Engine < Rails::Engine

    initializer "rizzo.configure_rails_initialization" do |app|

      app.routes.prepend do
        match 'global_head'    => 'global_resources#head'
        match 'global_header'  => 'global_resources#header'
        match 'global_footer'  => 'global_resources#footer'
        match 'breadcrumb'     => 'global_resources#breadcrumb'
      end

    end

  end
end