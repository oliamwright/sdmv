$(function () {
  iconBase = "https://maps.google.com/mapfiles/kml/pal4/";

  venue_markers = [];
  person_markers = [];

  mapCanvas = $('#map')[0];
  mapOptions = {
    center: new google.maps.LatLng(40.7468, -73.9468),
    zoom: 14,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };
  map = new google.maps.Map(mapCanvas, mapOptions);

  // Update Google Map Makers for Venue objects
  // This is called as Ajax callback
  window.update_venue_markers = function(venue_data) {
    for (var i = 0; i < venue_markers.length; i++) {
      venue_markers[i].setMap(null);
    }
    venue_markers = [];

    venue_data_list = JSON.parse(venue_data);
    for (var i = 0; i < venue_data_list.length; i++) {
      latlng = new google.maps.LatLng(venue_data_list[i].x, venue_data_list[i].y);
      marker = new google.maps.Marker({
        position: latlng,
        icon: iconBase + "icon63.png",
        map: map,
        title: "Venue " + (i+1) + " (" + venue_data_list[i].x + ", " + venue_data_list[i].y + ")"
      });

      venue_markers.push(marker);
    }
  }

  window.update_person_markers = function(person_data) {
    for (var i = 0; i < person_markers.length; i++) {
      person_markers[i].setMap(null);
    }

    person_data_list = JSON.parse(person_data);
    for (var i = 0; i < person_data_list.length; i++) {
      latlng = new google.maps.LatLng(person_data_list[i].x, person_data_list[i].y);
      marker = new google.maps.Marker({
        position: latlng,
        map: map,
        title: "Person " + (i+1) + " (" + person_data_list[i].x + ", " + person_data_list[i].y + ")"
      });

      person_markers.push(marker);
    }
  }
});