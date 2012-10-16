class GlobalResourcesController < GlobalController
  
  helper GlobalResourcesHelper

  layout nil

  def head
    render :template => "layouts/#{ params[:bare]? 'bare' : 'core' }/_head_snippet"
  end

  def header
    render :template => "layouts/#{ params[:bare]? 'bare' : 'core' }/_master_head"
  end

  def footer
    render :template => "layouts/#{ params[:bare]? 'bare' : 'core' }/_footer_snippet"
  end

  def index
    render '/global/index', :layout=>"#{params[:bare]? 'bare' : 'core'}"
  end

end
