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
          dividerTheme: DividerThemeData(color: Colors.transparent),
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
                padding: EdgeInsets.all(5.0),
                child: Image(
                  image: AssetImage('assets/logo.png'),
                  height: 75,
                ),
              ),
            ),
            buildMap(_user, _fountains),
            Spacer(),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 90,
                  child: Row(
                    children: [
                      Icon(Icons.local_drink_outlined),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              "Stay hydrated!",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 300,
                              child: Text(
                                "To contribute or learn more please click on the logos below!",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
                child: Image.asset('assets/tum.png', height: 30),
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
                child: Image.asset('assets/lhm.png', height: 40),
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
                child: Image.asset('assets/refill.png', height: 30),
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
