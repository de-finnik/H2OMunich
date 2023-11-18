import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hackatum23/fountains.dart';
import 'package:hackatum23/map.dart';
import 'package:latlong2/latlong.dart';

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
          scaffoldBackgroundColor: Color.fromARGB(255, 220, 171, 65),
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
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
              height: 10,
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
            buildMap(_user, _fountains),
          ],
        ),
      ),
      /*bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color.fromARGB(255, 37, 38, 82),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            label: "Home",
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: "Info",
            icon: Icon(Icons.info),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),*/
    );
  }
}
