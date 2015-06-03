$(function () {
  iconBase = "https://maps.google.com/mapfiles/kml/pal4/";

  venue_markers = [];   // Venue Marker Objects
  person_markers = [];  // Person Marker Objects
  item_markers = [];    // Item
  news_markers = [];    // News
  social_markers = [];  // Social

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
      latlng = new google.maps.LatLng(venue_data_list[i].y, venue_data_list[i].x);
      marker = new google.maps.Marker({
        position: latlng,
        icon: iconBase + "icon63.png",
        map: map,
        title: "Location " + (i+1) + " (" + venue_data_list[i].x + ", " + venue_data_list[i].y + ")"
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
      latlng = new google.maps.LatLng(item_data_list[i].y, item_data_list[i].x);
      marker = new google.maps.Marker({
        position: latlng,
        icon: iconBase + "icon29.png",
        map: map,
        title: "Item " + (i+1) + " (" + item_data_list[i].x + ", " + item_data_list[i].y + ")"
      });

      item_markers.push(marker);
    }
  }

  // Update google map markers for Person objects
  window.update_person_markers = function(person_data) {
    for (var i = 0; i < person_markers.length; i++) {
      person_markers[i].setMap(null);
    }
    person_markers = [];

    person_data_list = JSON.parse(person_data);
    for (var i = 0; i < person_data_list.length; i++) {
      latlng = new google.maps.LatLng(person_data_list[i].y, person_data_list[i].x);
      marker = new google.maps.Marker({
        position: latlng,
        map: map,
        title: "Person " + (i+1) + " (" + person_data_list[i].x + ", " + person_data_list[i].y + ")"
      });

      person_markers.push(marker);
    }
  }

  window.update_news_markers = function() {
    // Update news markers
    for (var i = 0; i < news_markers.length; i++) {
      news_markers[i].setMap(null);
    }
    news_markers = [];

    news_long = $('#news_location_long').val();
    news_lat = $('#news_location_lat').val();
    if (news_long != '' && news_lat != '') {
      latlong = new google.maps.LatLng(parseFloat(news_lat), parseFloat(news_long));
      marker = new google.maps.Marker({
        position: latlong,
        map: map,
        icon: iconBase + "icon24.png",
        title: "News (" + news_long + ", " + news_lat + ")"
      });

      news_markers.push(marker);
    }
  }

  window.update_social_markers = function() {
    // Update social markers
    for (var i = 0; i < social_markers.length; i++) {
      social_markers[i].setMap(null);
    }
    social_markers = [];

    social_long = $('#social_location_long').val();
    social_lat = $('#social_location_lat').val();
    if (social_long != '' && social_lat != '') {
      latlong = new google.maps.LatLng(parseFloat(social_lat), parseFloat(social_long));
      marker = new google.maps.Marker({
        position: latlong,
        map: map,
        icon: iconBase + "icon25.png",
        title: "Social (" + social_long + ", " + social_lat + ")"
      });

      social_markers.push(marker);
    }
  }
});