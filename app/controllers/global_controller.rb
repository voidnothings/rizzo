class GlobalController < ActionController::Base

  helper_method :current_section

  def current_section
    params[:c] || 'destinations'
  end

end
