class GlobalResourcesController < GlobalController
  
  helper GlobalResourcesHelper

  layout nil

  def head
    render :template => 'layouts/core_partials/_head_snippet'
  end

  def header
    render :template => 'layouts/core_partials/_master_head'
  end

  def footer
    render :template => 'layouts/core_partials/_footer-snippet'
  end

  def index
    render '/global/index', :layout=>'core'
  end

end
