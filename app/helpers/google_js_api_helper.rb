module GoogleJsApiHelper

  def js_api_script(js_api_key = 'ABQIAAAADUr8Vd6I7bfZ5k4c27F7KxR5cxXriAJsP5a75Cx4cnHTXGWMNxQxhFddQkNg7EBCllU86qgA_ugglg')
    javascript_path "http://www.google.com/jsapi?key=#{js_api_key}"
  end

  def load_detail_map_script
    return<<-END
    google.load("maps", 3.9, {other_params:"sensor=false"});
    google.setOnLoadCallback(function() {
            var options = {
                  zoom: 10,
                  center: new google.maps.LatLng(-26.616507,-56.409463),
                  mapTypeId: google.maps.MapTypeId.ROADMAP
            }
            map = new google.maps.Map(document.getElementById('map_canvas'), options);
    });
    END
  end

end
