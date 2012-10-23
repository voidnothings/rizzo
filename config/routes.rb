Rizzo::Application.routes.draw do

  match 'head' => 'head#index'  
  match 'global'                => 'global_resources#index'
  match 'breadcrumb'            => 'global_resources#breadcrumb'
  match "r/:encrypted_url"      => 'redirector#show', :as => :redirector

  match 'global-head'           => 'global_resources#head'
  match 'global-body-header'    => 'global_resources#header'
  match 'global-body-footer'    => 'global_resources#footer'
  match 'secure/global-head'           => 'global_resources#head',   :defaults => { :secure => "true" }
  match 'secure/global-body-header'    => 'global_resources#header', :defaults => { :secure => "true" }
  match 'secure/global-body-footer'    => 'global_resources#footer', :defaults => { :secure => "true" }

end if defined?(Rizzo::Application)
