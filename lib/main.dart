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
      title: 'oasis',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: const Color.fromARGB(255, 220, 171, 65),
          fontFamily: GoogleFonts.raleway().fontFamily),
      home: const MyHomePage(title: 'Fountain Finder'),
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
                padding: EdgeInsets.all(2.0),
                child: Image(
                  image: AssetImage('assets/logo.png'),
                  height: 75,
                ),
              ),
            ),
            buildMap(_user, _fountains),
            Spacer(),
            Text("Stay hydrated!"),
            Text("To contribute or learn more please click on the logos:"),
            Spacer(),
          ],
        ),
      ),
      persistentFooterButtons: <Widget>[
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              TextButton(
                onPressed: () {
                  openLink("hack.tum.de");
                },
                child: Image.asset('assets/tum.png', height: 50),
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                      Color.fromARGB(255, 220, 171, 65)),
                ),
              ),
              Spacer(),
              TextButton(
                onPressed: () {
                  openLink("muenchen.de");
                },
                child: Image.asset('assets/lhm.png', height: 50),
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                      Color.fromARGB(255, 220, 171, 65)),
                ),
              ),
              Spacer(),
              TextButton(
                onPressed: () {
                  openLink("refill-deutschland.de");
                },
                child: Image.asset('assets/refill.png', height: 50),
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                      Color.fromARGB(255, 220, 171, 65)),
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ],
    );
  }
}
