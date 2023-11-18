import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hackatum23/fountains.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: const Color.fromARGB(255, 212, 245, 254),
          fontFamily: GoogleFonts.raleway().fontFamily),
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
  List<Fountain>? _fountains;
  LatLng? _user;
  Widget buildMap() {
    MapController controller = MapController();
    return FlutterMap(
      mapController: controller,
      options: const MapOptions(
        initialCenter: LatLng(48.137648, 11.574628),
        initialZoom: 13,
        minZoom: 10,
        maxZoom: 19,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
        ),
        _fountains == null
            ? const CircularProgressIndicator()
            : MarkerLayer(
                markers: _fountains!
                    .map((e) => Marker(point: e.latLng, child: e.icon))
                    .toList(),
              ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    fetchFountains().then((list) {
      setState(() {
        _fountains = list;
      });
    });
    Geolocator.getCurrentPosition().then((position) {
      setState(() {
        _user = LatLng(position.latitude, position.longitude);
      });
    });
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Image(
                  image: AssetImage('assets/logo.png'),
                  height: 75,
                ),
              ),
            ),
            Stack(
              children: [
                SizedBox(
                  height: 400,
                  child: buildMap(),
                ),
                Center(
                  child: Card(
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      onTap: () async {
                        //TODO open navigation
                        if (_user == null || _fountains == null) {
                          return;
                        }
                        navigateToFountain(
                            findNearestFountain(_user!, _fountains!));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.water_drop_outlined),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 15, right: 15),
                              child: _fountains == null || _user == null
                                  ? const CircularProgressIndicator()
                                  : Column(
                                      children: [
                                        Text(findNearestFountain(
                                                _user!, _fountains!)
                                            .name),
                                        Text(
                                            "${distance(_user!, findNearestFountain(_user!, _fountains!).latLng).round()}m")
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
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(items: [
        const BottomNavigationBarItem(
          label: "Home",
          icon: Icon(Icons.home),
        ),
        const BottomNavigationBarItem(
          label: "Info",
          icon: Icon(Icons.info),
        ),
      ]),
    );
  }
}
