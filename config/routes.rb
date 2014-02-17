Rizzo::Application.routes.draw do

  get 'head'                         => 'head#index'
  get 'breadcrumb'                   => 'global_resources#breadcrumb'
  get "r/:encrypted_url"             => 'redirector#show', :as => :redirector
  get "redirector"                   => 'redirector#internal'

  # Core
  get 'client-solutions/global-head'        => 'global_resources#show', :defaults => { :snippet => "head", :cs => "true" }
  get 'client-solutions/global-body-header' => 'global_resources#show', :defaults => { :snippet => "body_header", :cs => "true" }
  get 'client-solutions/global-body-footer' => 'global_resources#show', :defaults => { :snippet => "body_footer", :cs => "true" }

  # Legacy
  get 'global-head'                  => 'global_resources#show', :defaults => { :snippet => "head" }
  get 'global-head-thorntree'        => 'global_resources#show', :defaults => { :snippet => "head", :suppress_tynt => "true" }
  get 'global-body-header'           => 'global_resources#show', :defaults => { :snippet => "body_header", :scope => 'legacy' }
  get 'global-body-footer'           => 'global_resources#show', :defaults => { :snippet => "body_footer" }

  get 'noscript/global-head'         => 'global_resources#show', :defaults => { :snippet => "head", :noscript => "true"}
  get 'noscript/global-body-footer'  => 'global_resources#show', :defaults => { :snippet => "body_footer", :noscript => "true"}

  get 'secure/global-head'           => 'global_resources#show', :defaults => { :snippet => "head", :secure => "true", :suppress_tynt => "true" }
  get 'secure/global-body-header'    => 'global_resources#show', :defaults => { :snippet => "body_header", :secure => "true" }
  get 'secure/global-body-footer'    => 'global_resources#show', :defaults => { :snippet => "body_footer", :secure => "true" }

  get 'secure/noscript/global-head'         => 'global_resources#show', :defaults => { :snippet => "head", :noscript => "true"}
  get 'secure/noscript/global-body-footer'  => 'global_resources#show', :defaults => { :snippet => "body_footer", :noscript => "true"}

  get 'global'                           => 'global_resources#index'
  get 'secure/global'                    => 'global_resources#index', :defaults => { :secure => "true" }
  get 'legacy'                           => 'global_resources#legacy'
  get 'responsive'                       => 'global_resources#responsive'
  get 'homepage'                         => 'global_resources#homepage'

  # Styleguide
  get 'styleguide/'                                    => 'styleguide#colours'
  get 'styleguide/ui-components'                       => 'styleguide#colours'
  get 'styleguide/ui-components/secondary-nav'         => 'styleguide#secondaryNavigation'
  get 'styleguide/ui-components/left-nav'              => 'styleguide#leftNavigation'
  get 'styleguide/ui-components/navigational_dropdown' => 'styleguide#navigational_dropdown'
  get 'styleguide/ui-components/cards'                 => 'styleguide#cards'
  get 'styleguide/ui-components/buttons'               => 'styleguide#buttons'
  get 'styleguide/ui-components/badges'                => 'styleguide#badges'
  get 'styleguide/ui-components/page-title'            => 'styleguide#pageTitle'
  get 'styleguide/ui-components/typography'            => 'styleguide#typography'
  get 'styleguide/ui-components/colours'               => 'styleguide#colours'
  get 'styleguide/ui-components/ui-colours'            => 'styleguide#uiColours'
  get 'styleguide/ui-components/icons'                 => 'styleguide#icons'
  get 'styleguide/ui-components/pagination'            => 'styleguide#pagination'
  get 'styleguide/ui-components/proportional-grid'     => 'styleguide#proportionalGrid'
  get 'styleguide/ui-components/cards-grid'            => 'styleguide#cardsGrid'
  get 'styleguide/ui-components/activity_list'         => 'styleguide#activity_list'
  get 'styleguide/ui-components/tags'                  => 'styleguide#tags'
  get 'styleguide/ui-components/inputs'                => 'styleguide#inputs'
  get 'styleguide/ui-components/dropdown'              => 'styleguide#dropdown'
  get 'styleguide/ui-components/range-slider'          => 'styleguide#rangeSlider'
  get 'styleguide/ui-components/alerts'                => 'styleguide#alerts'

  get 'styleguide/js-components'                       => 'styleguide#toggle_active'
  get 'styleguide/js-components/toggle-active'         => 'styleguide#toggle_active'
  get 'styleguide/js-components/proximity-loader'      => 'styleguide#proximity_loader'
  get 'styleguide/js-components/asset-reveal'          => 'styleguide#asset_reveal'
  get 'styleguide/js-components/image-helper'          => 'styleguide#image_helper'

  get 'styleguide/sass-utilities/'                     => 'styleguide#utilityClasses'
  get 'styleguide/sass-utilities/utility-classes'      => 'styleguide#utilityClasses'
  get 'styleguide/sass-utilities/legacy'               => 'styleguide#legacy'
  get 'styleguide/sass-utilities/no-js'                => 'styleguide#noJs'
  get 'styleguide/sass-utilities/lp-specific'          => 'styleguide#lpSpecific'
  get 'styleguide/sass-utilities/responsive'           => 'styleguide#responsive'

  #===== yeoman hook =====#
  # NB! The above line is required for our yeoman generator and should not be changed.

end if defined?(Rizzo::Application)
