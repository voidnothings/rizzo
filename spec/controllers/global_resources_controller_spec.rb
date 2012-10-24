require 'spec_helper'

describe GlobalResourcesController do

  describe "GET new global head snippet" do
   
    context "default" do
      get :head
      response.should render_template("layouts/core/_head_snippet") 
    end
    
    context "secure" do

    end

  end
end
# 
# 
# __END__
# require 'spec_helper'
# 
# describe "availability_searches/create.html.erb" do
#   it "should render lodgings/partials/_rooms.html.haml" do
#     stub_template("lodgings/partials/_rooms.html.haml" => "rendered partial")
#     render
# 
#     rendered.should include("rendered partial")
#   end
# end
# 
# 
#     it "resets negative page param to 1" do
#       LodgingListPresenter.should_receive(:for).with(hash_including({page: 1})).and_return(hash)
# 
#       get :index, page: -100, place_id: place.to_param
#     end
#     
