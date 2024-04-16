import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

// files
import 'app_bar.dart';
import 'bottom_bar.dart';
import 'body.dart';
import 'class_def.dart';
import 'decode_location.dart';
import 'get_weather.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainApp();
}

class _MainApp extends State<MainApp> {
  final myController = TextEditingController();
  String local = '';
  bool _error = false;
  Coord coord = Coord(0, 0);

  DecodeCity? city;
  Weather? weather;

  late Future<List<GeoData>> futureGeoData;

  void setError(bool value, String explain) {
    setState(() {
      _error = value;
      if (explain != '') {
        local = explain;
      }
    });
  }

  void updateCity(Coord coordinates) async {
    // Appel à la fonction qui récupère les informations de la ville
    try {
      DecodeCity tmp = await fetchCityFromCoord(coordinates);
      setState(() {
        city = tmp;
      });
    } catch (e) {
      setState(() {
        _error = true;
        local = e.toString();
      });
      print(e);
      // rethrow;
    }
  }

  void updateWeather(Coord coordinates) async {
    // Appel à la fonction qui récupère les informations météorologiques actuelles
    try {
      Weather tmp = await fetchWeather(coordinates);
      setState(() {
        weather = tmp;
      });
    } catch (e) {
      setState(() {
        _error = true;
        local = e.toString();
      });
      print(e);
      // rethrow;
    }
  }

  void setCoord(double longitude, double latitude) {
    // print('setCoord: long=$longitude, lat=$latitude ');
    setState(() {
      coord = Coord(latitude, longitude);
      // local = '$latitude $longitude';
    });
    try {
      updateCity(coord);
      updateWeather(coord);
    } catch (e) {
      print('setCoord error: $e');
      // rethrow;
    }
  }

  void setChoice(String choice) async {
    if (choice == 'city') {
      setState(() {
        _error = false;
      });
    } else if (choice == 'gps') {
      // trying to get localisation
      _getCurrentLocation();
    } else {
      setState(() {
        local = '';
        _error = false;
      });
    }
  }

  Future<Position?> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      print('position = $position');
      setCoord(position.longitude, position.latitude);
      setState(() {
        // local = '${position.latitude} ${position.longitude}';
        _error = false;
      });
      return position;
    } catch (e) {
      print('Error getting current location: $e');
      setState(() {
        local =
            'Geolocation is not available, please enable it in your App settings';
        _error = true;
        coord = Coord(0, 0);
      });
      return null;
    }
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          extendBody: true, //false
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            // backgroundColor: const Color.fromRGBO(102, 64, 203, 1),
            backgroundColor: Colors.transparent,
            title: MyAppBar(
              myController: myController,
              setChoice: setChoice,
              setError: setError,
              setCoord: setCoord,
            ),
          ),
          body: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("image/background5.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: TabBarView(
              children: [
                MyTabWidget(
                  title: 'Currently',
                  localisation: local,
                  isError: _error,
                  coord: coord,
                  city: city,
                  weather: weather,
                ),
                MyTabWidget(
                  title: 'Today',
                  localisation: local,
                  isError: _error,
                  coord: coord,
                  city: city,
                  weather: weather,
                ),
                MyTabWidget(
                  title: 'Weekly',
                  localisation: local,
                  isError: _error,
                  coord: coord,
                  city: city,
                  weather: weather,
                ),
              ],
            ),
          ),
          bottomNavigationBar: const MyBottonBarWidget(),
        ),
      ),
    );
  }
}
