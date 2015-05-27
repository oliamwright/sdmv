$(function () {
  iconBase = "https://maps.google.com/mapfiles/kml/pal4/";

  venue_markers = [];
  person_markers = [];
  item_markers = [];

  mapCanvas = $('#map')[0];
  mapOptions = {
    center: new google.maps.LatLng(40.7468, -73.9468),
    zoom: 16,
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

  // Update Google Map Makers for Item objects
  // This is called as Ajax callback
  window.update_item_markers = function(item_data) {
    for (var i = 0; i < item_markers.length; i++) {
      item_markers[i].setMap(null);
    }
    item_markers = [];

    item_data_list = JSON.parse(item_data);
    for (var i = 0; i < item_data_list.length; i++) {
      latlng = new google.maps.LatLng(item_data_list[i].x, item_data_list[i].y);
      marker = new google.maps.Marker({
        position: latlng,
        icon: iconBase + "icon29.png",
        map: map,
        title: "Item " + (i+1) + " (" + item_data_list[i].x + ", " + item_data_list[i].y + ")"
      });

      item_markers.push(marker);
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