$(document).ready(function(){
  if($('.user_info_list').length)
  {
    // $("a[href='#mapdiv']").on('show.bs.tab', function(e) {
        loadInternationalMap();
    // });
  }
});

function add_markers(handler)
{
  var marker_type;
  map_data = $('#map_data').val();
  json_array = jQuery.parseJSON(map_data);
  markers = []
  for(var i = 0; i < json_array.length; i++){
    if((json_array[i].lat !== null) && (json_array[i].lng !== null))
    {  
      var duplicate_coordinates_array = [];
      var latitude, longitude;
      duplicate_coordinates_array = check_lat_lng_existance(json_array, json_array[i].lat, json_array[i].lng);
      if((duplicate_coordinates_array.length)>1)
      {
        latitude = json_array[i].lat;
        longitude = json_array[i].lng;
        var infowindow = create_listed_info_window(duplicate_coordinates_array, json_array);
        marker_type = "http://maps.google.com/mapfiles/ms/icons/blue-dot.png";
      }
      else
      {  
      var infowindow = '<div class="user_info_list col-md-12">'+
                       '<a href="/users/'+json_array[i].id+'">'+
                       '<div class=" map_box ">'+
                       '<img src="'+json_array[i].picture_url+'" class="img-responsive">'+
                       '</div>'+
                       '<div class="address_list ">'+
                       '<div class="infowindow_text">'+
                       '<p id="nom">'+json_array[i].nom+'</p>'+
                       '</div>'+
                       '<div class="infowindow_text">'+
                       '<p id="promo">'+json_array[i].promo+'</p>'+
                       '</div>'+
                       '<div class="infowindow_text">'+
                       '<p id="occupation">'+json_array[i].address+'</p>'+
                       '</div>'+
                       '<div class="infowindow_text">'+
                       '<p id="occupation">'+json_array[i].ident_active+'</p>'+
                       '</div>'+
                       '</div>'+
                       '</div>'+
                       '</a>'+
                       '</div>';
        latitude = json_array[i].lat;
        longitude = json_array[i].lng; 
        marker_type = "http://maps.google.com/mapfiles/ms/icons/red-dot.png";              
        }                 
      markers = handler.addMarkers([
            {
              "lat": latitude,
              "lng": longitude,
              "picture": {
              url: marker_type,
              width:  36,
              height: 36
              },
              "infowindow": infowindow
            }
          ]);
    }  
  }
  google.maps.event.trigger(map, "resize");
  // to center on a marker
  if(markers.length > 0)
  {
    handler.map.centerOn(markers[0]); 
  }
  // to set the map zoom
  handler.getMap().setZoom(3);
}


var loadInternationalMap = function() {

  handler = Gmaps.build('Google');
  handler.buildMap({ provider: {}, internal: {id: 'map'}}, function(){
    add_markers(handler);
  });

}

function check_lat_lng_existance(json_array, lat, lng)
{
  var similar_coordiates = [];
  for(var j = 0; j<json_array.length; j++)
  {
    if ((json_array[j].lat == lat) && (json_array[j].lng == lng))
    {
      similar_coordiates.push(j);
    }
  }

  return similar_coordiates;
}

function create_listed_info_window(duplicate_coordinates_array, json_array)
{   
    var infowindow = '<div class="user_info_list col-md-12">';
    for(var i = 0; i < duplicate_coordinates_array.length; i ++)
    { 
      var index = duplicate_coordinates_array[i];
      json_object = json_array[index];
      infowindow = infowindow + '<p><a href="/users/'+json_object.id+'">'+json_object.nom+' ('+json_object.promo+')</a></p>';
      // json_array.splice( index, 1 );                   
    } 
    infowindow = infowindow +  '</div>';

    return infowindow;                
}