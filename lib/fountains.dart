import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class Fountain {
  LatLng latLng;
  Widget icon;
  String name;
  Fountain(this.latLng, this.icon, this.name);
}

Future<List<Fountain>> fetchFountains() async {
  var response = await http.get(Uri.parse(
      'https://geoportal.muenchen.de/geoserver/baug_wfs/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=baug_wfs:opendata_trinkwasserbrunnen&outputFormat=application/json&srsName=EPSG:4326'));
  var json = jsonDecode(response.body) as Map<String, dynamic>;
  List<Fountain> list = List.empty(growable: true);
  for (var element in json['features']) {
    var coord = element['geometry']['coordinates'];
    var latLng = LatLng(coord[1], coord[0]);
    Fountain fountain = Fountain(
        latLng,
        IconButton(
          onPressed: () {
            navigateToLatLng(latLng);
          },
          icon: const Icon(
            Icons.water_drop,
            size: 20,
            color: Colors.blue,
          ),
        ),
        element['properties']['bezeichnung']);
    list.add(fountain);
  }
  response = await http.get(Uri.parse(
      'https://api.ofdb.io/v0/search?bbox=48.05949581959207%2C11.346473693847658%2C48.192412189186236%2C11.655464172363281&text=refill-station%20refill-trinkbrunnen%20refill%20refill-sticker%20trinkwasser%20leitungswasser%20trinkwasserbrunnen%20trinkbrunnen&categories=2cd00bebec0c48ba9db761da48678134%2C77b3c33a92554bcf8e8c2c86cedd6f6f'));
  json = jsonDecode(response.body) as Map<String, dynamic>;
  for (var element in json['visible']) {
    var latLng = LatLng(element['lat'], element['lng']);
    Fountain m = Fountain(
      latLng,
      IconButton(
        onPressed: () {
          navigateToLatLng(latLng);
        },
        icon: const Icon(
          Icons.water_drop_outlined,
          size: 20,
          color: Colors.blue,
        ),
      ),
      element['title'],
    );
    list.add(m);
  }
  return list;
}

Fountain findNearestFountain(LatLng user, List<Fountain> fountains) {
  fountains.sort((f1, f2) =>
      distance(user, f1.latLng).compareTo(distance(user, f2.latLng)));
  return fountains.first;
}

double distance(LatLng one, LatLng two) {
  return Geolocator.distanceBetween(
      one.latitude, one.longitude, two.latitude, two.longitude);
}

void navigateToFountain(Fountain fountain) async {
  navigateToLatLng(fountain.latLng);
}

void navigateToLatLng(LatLng latLng) async {
  String googleUrl =
      'https://www.google.com/maps/search/?api=1&query=${latLng.latitude},${latLng.longitude}';

  if (await canLaunchUrl(Uri.parse(googleUrl))) {
    await launchUrl(Uri.parse(googleUrl));
  } else {
    throw "Couldn't launch Map";
  }
}

void openLink(String url) async {
  if (await canLaunchUrl(Uri.parse("https://${url}"))) {
    await launchUrl(Uri.parse("https://${url}"));
  } else {
    throw "Couldn't open URL";
  }
}
