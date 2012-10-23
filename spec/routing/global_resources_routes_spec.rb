require 'spec_helper'

describe "global service routes" do
  
  it "routes /global-head to global-head service" do
    get('/global-head').should route_to("global_resources#head")
  end

  it "routes /global-body-header to global-head service" do
    get('/global-body-header').should route_to("global_resources#header")
  end

  it "routes /global-body-footer to global-head service" do
    get('/global-body-footer').should route_to("global_resources#footer")
  end


  it "routes /secure/global-head to global-head service" do
    get('/secure/global-head').should route_to("global_resources#head", :secure => "true")
  end

  it "routes /secure/global-body-header to global-head service" do
    get('/secure/global-body-header').should route_to("global_resources#header", :secure => "true")
  end

  it "routes /secure/global-body-footer to global-head service" do
    get('/secure/global-body-footer').should route_to("global_resources#footer", :secure => "true")
  end

end
