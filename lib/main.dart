import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:hackatum23/fountains.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Wasser für München'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  MapController mapController = MapController(
    initPosition: GeoPoint(latitude: 48.137648, longitude: 11.574628),
    areaLimit: const BoundingBox.world(),
  );

  void _addMarkers() {
    fetchFountains().then((value) {
      for (var element in value) {
        mapController.addMarker(element);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: <Widget>[
          OSMFlutter(
            controller: mapController,
            osmOption: OSMOption(
              zoomOption: const ZoomOption(
                initZoom: 11,
                minZoomLevel: 10,
                maxZoomLevel: 19,
                stepZoom: 1.0,
              ),
              userLocationMarker: UserLocationMaker(
                personMarker: const MarkerIcon(
                  icon: Icon(
                    Icons.location_history_rounded,
                    color: Colors.red,
                    size: 48,
                  ),
                ),
                directionArrowMarker: const MarkerIcon(
                  icon: Icon(
                    Icons.double_arrow,
                    size: 48,
                  ),
                ),
              ),
              roadConfiguration: RoadOption(
                roadColor: Colors.yellowAccent,
              ),
              markerOption: MarkerOption(
                  defaultMarker: const MarkerIcon(
                icon: Icon(
                  Icons.water_drop,
                  color: Colors.blue,
                  size: 30,
                ),
              )),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: _addMarkers),
    );
  }
}
