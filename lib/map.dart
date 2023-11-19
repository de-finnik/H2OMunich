import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hackatum23/fountains.dart';
import 'package:latlong2/latlong.dart';

Widget buildMap(LatLng? user, List<Fountain>? fountains) {
  return Stack(
    children: [
      SizedBox(
        height: 400,
        child: _buildFlutterMap(fountains, user),
      ),
      Center(
        child: Card(
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: () async {
              if (user == null || fountains == null) {
                return;
              }
              navigateToFountain(findNearestFountain(user, fountains));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.water_drop_outlined),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: fountains == null || user == null
                        ? const CircularProgressIndicator()
                        : Column(
                            children: [
                              Text(findNearestFountain(user, fountains).name),
                              Text(
                                  "${distance(user, findNearestFountain(user, fountains).latLng).round()}m")
                            ],
                          ),
                  ),
                  const Column(
                    children: [
                      Icon(Icons.turn_right),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

Widget _buildFlutterMap(List<Fountain>? fountains, LatLng? user) {
  MapController controller = MapController();
  return FlutterMap(
    mapController: controller,
    options: const MapOptions(
      initialCenter: LatLng(48.137648, 11.574628),
      initialZoom: 12,
      minZoom: 11,
      maxZoom: 19,
    ),
    children: [
      TileLayer(
        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        userAgentPackageName: 'com.example.app',
      ),
      fountains == null
          ? const CircularProgressIndicator()
          : MarkerLayer(
              markers: fountains
                  .map((e) => Marker(point: e.latLng, child: e.icon))
                  .toList(),
            ),
    ],
  );
}
