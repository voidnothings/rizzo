class GlobalResourcesController < GlobalController
  
  helper GlobalResourcesHelper
  layout nil

  def head
    render :template => 'layouts/partials/_head'
  end

  def header
    render :template => 'layouts/partials/_header', locals: { section: params[:c] }
  end

  def footer
    render :template => 'layouts/partials/_footer'
  end

  def index
    render '/global/index', :layout=>'core'
  end

end
