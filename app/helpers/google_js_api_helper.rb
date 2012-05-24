module GoogleJsApiHelper
  
  def js_api_script(js_api_key = 'ABQIAAAADUr8Vd6I7bfZ5k4c27F7KxR5cxXriAJsP5a75Cx4cnHTXGWMNxQxhFddQkNg7EBCllU86qgA_ugglg')
    javascript_path "http://www.google.com/jsapi?key=#{js_api_key}"
  end
    
end